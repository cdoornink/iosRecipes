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
                
                if recipe["retired"] as? Int != 1 {
                    let recipeName = recipe["title"] as! String
                    let shortName = recipe["short"] as? String
                    let photo = UIImage(named: recipe["id"] as! String)
                    let ingredients = recipe["ingredients"] as? Array<Dictionary<String, Any>>
                    let directions = recipe["instructions"] as? Array<String>
                    let onShoppingList = recipe["onShoppingList"] as? Bool
                    let onMenu = recipe["onMenu"] as? Bool
                    let isCooked = recipe["isCooked"] as? Bool
                    let cookedCount = recipe["cookedCount"] as? Int
                    let prepTime = recipe["prepTime"] as? Int
                    let cookTime = recipe["cookTime"] as? Int
                    let serves = recipe["serves"] as? Int
                    let lastCookedString = recipe["lastCooked"] as? String
                    let cocktail = recipe["cocktail"] as? Bool
                    let dessert = recipe["dessert"] as? Bool
                    let firebaseRef = childSnapshot.key
                    
                    let lastCooked: Date?
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    if lastCookedString == nil {
                        lastCooked = nil
                    } else {
                        lastCooked = formatter.date(from: lastCookedString!)
                    }
                    
                    guard let entry = Recipe(name: recipeName, shortName: shortName ?? recipeName, photo: photo, ingredients: ingredients, directions: directions, onShoppingList: onShoppingList, onMenu: onMenu, isCooked: isCooked, cookedCount: cookedCount, prepTime: prepTime, cookTime: cookTime, serves: serves, lastCooked: lastCooked, cocktail: cocktail, dessert: dessert, firebaseRef: firebaseRef) else {
                        fatalError("Unable to instanstiate recipe")
                    }
                    
                    recipes += [entry]
                }
                
            }
            recipes = recipes.sorted(by: {$0.name < $1.name})
            callback(recipes)
        })
    }
    
    /*
     loadGroceryListItems
     
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
                let manuallyAdded = item["manuallyAdded"] as? Int == 1
                let inCart = item["inCart"] as? Bool
                let firebaseRef = childSnapshot.key
                
                
                guard let entry = GroceryListItem(name: name, recipes: recipes, manuallyAdded: manuallyAdded, inCart: inCart ?? false, firebaseRef: firebaseRef) else {
                    fatalError("Unable to instanstiate GroceryListItem")
                }
                
                items += [entry]
                
            }
            callback(items)
        })
    }
    
    /*
     loadGroceryListItems
     
     Pulls the list of previously added grocery list items to suggest to the user when they are typing in
     items to add to their grocery list.
     */
    func getItemSuggestions(callback: @escaping (Array<String>) -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("items").observe(.value, with: { (snapshot) in
            
            var items = [String]()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                let item = childSnapshot.value as? [String : AnyObject] ?? [:]
                
                let name = item["title"] as! String
                
                items += [name]
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
    func addItemToList(_ item: String, _ groceryListItems: Array<GroceryListItem>, _ recipe: Recipe? = nil, itemSuggestions: Array<String>? = []) {
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
        
        if duplicateFound == false {
            if recipe != nil {
                ref.child("shoppingList").childByAutoId().setValue(["title": item, "recipes": [recipe?.shortName]])
            } else {
                ref.child("shoppingList").childByAutoId().setValue(["title": item, "manuallyAdded": true])
                print("itemSuggestions = \(itemSuggestions)")
                if itemSuggestions!.count > 0 {
                    self.addItemToItemSuggestions(item, itemSuggestions!)
                }
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
    
    func removeRecipeFromList(_ recipe: Recipe, _ groceryListItems: Array<GroceryListItem>) {
        let items = groceryListItems.filter({ (item) -> Bool in
            return item.recipes?.contains(recipe.shortName) == true
        })
        
        items.forEach({ (item) in
            self.removeItemFromList(item, recipe)
        })
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("recipes").child(recipe.firebaseRef).child("onShoppingList").setValue(false)
    }
    
    func removeItemFromList(_ item: GroceryListItem, _ recipe: Recipe? = nil) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if recipe != nil && (item.recipes?.count != 1 || item.manuallyAdded == true) {
            //remove the recipe reference from the item
            let newRecipesArray = item.recipes?.filter({ (shortName) -> Bool in
                return shortName != recipe?.shortName
            })
            ref.child("shoppingList").child(item.firebaseRef).child("recipes").setValue(newRecipesArray)
        } else {
            //remove the item
            ref.child("shoppingList").child(item.firebaseRef).removeValue()
        }
    }
    
    func updateGroceryListItem(_ item: GroceryListItem) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("shoppingList").child(item.firebaseRef).setValue([
            "title": item.name,
            "recipes": item.recipes ?? [],
            "manuallyAdded": item.manuallyAdded,
            "inCart": item.inCart
        ])
        
    }
    
    func clearShoppingListAndReplaceMenu(_ recipes: Array<Recipe>) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("shoppingList").removeValue()
        recipes.forEach { (recipe) in
            if recipe.onMenu == true {
                ref.child("recipes").child(recipe.firebaseRef).child("onMenu").setValue(false)
            }
            if recipe.isCooked == true {
                ref.child("recipes").child(recipe.firebaseRef).child("isCooked").setValue(false)
            }
            if recipe.onShoppingList == true {
                ref.child("recipes").child(recipe.firebaseRef).child("onMenu").setValue(true)
                ref.child("recipes").child(recipe.firebaseRef).child("onShoppingList").setValue(false)
            }
        }
    }
    
    func toggleRecipeIsCooked(_ recipe: Recipe) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let recipeIsCooked = !recipe.isCooked!
        
        ref.child("recipes").child(recipe.firebaseRef).child("isCooked").setValue(recipeIsCooked)
        
        if recipeIsCooked {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = formatter.string(from: date)
            
            ref.child("recipes").child(recipe.firebaseRef).child("lastCooked").setValue(formattedDate)
        }
    }
    
    func addItemToItemSuggestions(_ item: String, _ itemSuggestions: Array<String>) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let matchedItem = itemSuggestions.filter {
            return $0.lowercased() == item.lowercased()
        }
        
        if (matchedItem.count == 0) {
            ref.child("items").childByAutoId().setValue(["title": item])
        }
    }

}

