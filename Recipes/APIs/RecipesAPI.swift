//
//  Recipes.swift
//  RecipesAPI
//
//  Created by Chris Doornink on 1/9/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

struct RecipesAPI {
    
    func getRecipes(callback: @escaping (Array<Recipe>) -> ()) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("recipes").observe(.value, with: { (snapshot) in
            
            var recipes = [Recipe]()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                let recipe = childSnapshot.value as? [String : AnyObject] ?? [:]
                
                let recipeName = recipe["title"] as! String
                let shortName = recipe["short"] as? String
                let photo = UIImage(named: recipe["id"] as! String)
                let ingredients = recipe["ingredients"] as? Array<Dictionary<String, Any>>
                let directions = recipe["instructions"] as? Array<String>
                let onShoppingList = recipe["onShoppingList"] as? Bool
                let firebaseRef = childSnapshot.key
                
                guard let entry = Recipe(name: recipeName, shortName: shortName ?? recipeName, photo: photo, ingredients: ingredients, directions: directions, onShoppingList: onShoppingList, firebaseRef: firebaseRef) else {
                    fatalError("Unable to instanstiate recipe")
                }
                
                recipes += [entry]
                
            }
            recipes = recipes.sorted(by: {$0.name < $1.name})
            callback(recipes)
        })
    }
    
    /*
     loadGroceryListItems - Private Function
     
     Pulls the list of grocery list items from firebase and creates a new GroceryListItem class
     for each item. This list should include both manually added items from the user as well as
     items that are added when a user adds a recipe to the Grocery List. This should not have
     to do any kind of de-duplication as that should be handled during the adding of items
     rather than the displaying of them.
     */
    func getGroceryListItems(callback: @escaping (Array<GroceryListItem>) -> ()) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("shoppingList").observe(.value, with: { (snapshot) in
            
            var items = [GroceryListItem]()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                let item = childSnapshot.value as? [String : AnyObject] ?? [:]
                
                let name = item["title"] as! String
                let recipes = item["recipes"] as? Array<String> ?? []
                let manuallyAdded = item["manuallyAdded"] as? Bool
                let inCart = item["inCart"] as? Bool
                let firebaseRef = childSnapshot.key
                
                
                guard let entry = GroceryListItem(name: name, recipes: recipes, manuallyAdded: manuallyAdded ?? false, inCart: inCart ?? false, firebaseRef: firebaseRef) else {
                    fatalError("Unable to instanstiate GroceryListItem")
                }
                
                items += [entry]
                
            }
            callback(items)
        })
    }
    
    /*
     addRecipeToList
     
     Takes a Recipe class and adds the ingredients that have been flagged as 'list': true
     Also marks the recipe as 'onShoppingList' in order to show the correct state for each
     recipe and allow for removal from the Grocery List.
     */
    func addRecipeToList(_ recipe: Recipe, _ groceryListItems: Array<GroceryListItem>) {
        print("add \(recipe.name) to the list")
        let ingredients = recipe.ingredients?.filter({ (ingredient) -> Bool in
            
            return ingredient["list"] as? Int == 1
        })
        
        ingredients?.forEach({ (ingredient) in
            self.addItemToList(ingredient["name"] as! String, groceryListItems, recipe)
        })
        
        var ref: DatabaseReference!

        ref = Database.database().reference()

        ref.child("recipes").child(recipe.firebaseRef).child("onShoppingList").setValue(true)
        
    }
    
    /*
     addItemToList
     
     Adds an item to the Grocery List, taking into account duplicates and pluralization, also marks if the
     item is part of a recipe.
     */
    func addItemToList(_ item: String, _ groceryListItems: Array<GroceryListItem>, _ recipe: Recipe? = nil) {
        print("add \(item) to the list")
        if item.count < 2 {
            return
        }
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        var pluralMatch = false
        var singularMatch = false
        var duplicateFound = false
        let duplicates = groceryListItems.filter { (savedItem) -> Bool in
            
            if duplicateFound {
                return false
            }
            
            // if item seems like a plural, search for the singular
            if item.hasSuffix("s") {
                var plural = savedItem.name
                plural.append("s")
                pluralMatch = plural.lowercased() == item.lowercased()
            }
            if item.hasSuffix("es") && pluralMatch == false {
                var plural = savedItem.name
                plural.append("es")
                pluralMatch = plural.lowercased() == item.lowercased()
            }
            // else search for the plural
            if item.hasSuffix("s") == false {
                var singular = savedItem.name
                singular.removeLast()
                singularMatch = singular.lowercased() == item.lowercased()
                if singularMatch == false {
                    singular.removeLast()
                    singularMatch = singular.lowercased() == item.lowercased()
                }
            }
            
            duplicateFound = pluralMatch || singularMatch || savedItem.name.lowercased() == item.lowercased()
            
            return duplicateFound
        }
        
        if duplicates.count == 0 {
            if recipe != nil {
                ref.child("shoppingList").childByAutoId().setValue(["title": item, "recipes": [recipe?.shortName]])
            } else {
                ref.child("shoppingList").childByAutoId().setValue(["title": item, "manuallyAdded": true])
            }
        } else {
            let duplicate = duplicates[0]
            
            if recipe != nil {
                if duplicate.recipes?.count != 0 {
                    duplicate.recipes! += [recipe!.shortName]
                } else {
                    duplicate.recipes = [recipe!.shortName]
                }
            } else {
                duplicate.manuallyAdded = true
            }
            
            var title = duplicate.name
            if pluralMatch {
                title = item
            }
            
            ref.child("shoppingList").child(duplicate.firebaseRef).setValue([
                "title": title,
                "recipes": duplicate.recipes ?? [],
                "manuallyAdded": duplicate.manuallyAdded,
                "inCart": duplicate.inCart
            ])
        }
    }
    

}

