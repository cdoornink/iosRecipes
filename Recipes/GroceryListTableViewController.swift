//
//  GroceryListTableViewController.swift
//  Recipes
//
//  Created by Chris Doornink on 1/7/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

class GroceryListTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: Properties
    @IBOutlet weak var itemAddBar: UISearchBar!
    
    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var groceryListItems = [GroceryListItem]()
    var organizedGroceryList = [Aisle]()
    var inputTextValue = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecipes()
        loadGroceryListItems()

        itemAddBar.setImage(UIImage(named: "add-to-cart-gray"), for: .search, state: .normal)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        itemAddBar.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return organizedGroceryList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizedGroceryList[section].items!.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if organizedGroceryList[section].items!.count > 0 {
            return 30
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if organizedGroceryList[section].items!.count > 0 {
            return organizedGroceryList[section].name
        }
        return ""
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListTableViewCell", for: indexPath) as? GroceryListTableViewCell else {
            fatalError("The dequeued cell is not an instance of GroceryListTableViewCell.")
        }
        
        let item = organizedGroceryList[indexPath.section].items![indexPath.row]
        
        cell.name.text = item.name
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // tableView.deleteRows(at: [indexPath], with: .fade)
            let itemToRemove = organizedGroceryList[indexPath.section].items![indexPath.row]
            
            self.ref.child("shoppingList").child(itemToRemove.firebaseRef).removeValue()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let newItem = searchBar.text {
            self.addItemToList(newItem)
        }
        searchBar.text = ""
    }
    
    // MARK: Private Methods
    
    private func addItemToList(_ item: String) {
        print("add \(item) to the list")
        self.ref.child("shoppingList").childByAutoId().setValue(["title": item])
    }
    
    private func loadRecipes() {
        
        ref = Database.database().reference()
        
        ref.child("recipes").observe(.value, with: { (snapshot) in
            
            var recipes = [Recipe]()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                let recipe = childSnapshot.value as? [String : AnyObject] ?? [:]
                
                let recipeName = recipe["title"] as! String
                let photo = UIImage(named: recipe["id"] as! String)
                let ingredients = recipe["ingredients"] as? Array<Dictionary<String, Any>>
                let directions = recipe["instructions"] as? Array<String>
                let onShoppingList = recipe["onShoppingList"] as? Bool
                
                guard let entry = Recipe(name: recipeName, photo: photo, ingredients: ingredients, directions: directions, onShoppingList: onShoppingList) else {
                    fatalError("Unable to instanstiate recipe")
                }
                
                recipes += [entry]
                
            }
            
            self.recipes = recipes.sorted(by: {$0.name < $1.name})
            self.filterRecipes()
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
    private func loadGroceryListItems() {
        
        ref = Database.database().reference()
        
        ref.child("shoppingList").observe(.value, with: { (snapshot) in
            
            var items = [GroceryListItem]()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                let item = childSnapshot.value as? [String : AnyObject] ?? [:]
                
                let name = item["title"] as! String
                let recipes = item["recipes"] as? Array<String>
                let inCart = item["inCart"] as? Bool
                let firebaseRef = childSnapshot.key
                
                
                guard let entry = GroceryListItem(name: name, recipes: recipes, inCart: inCart ?? false, firebaseRef: firebaseRef) else {
                    fatalError("Unable to instanstiate GroceryListItem")
                }
                
                items += [entry]
                
            }
            
            self.groceryListItems = items
            self.organizeItems()
            print(self.groceryListItems)
        })
    }
    
    /*
     organizeItems - Private Function
     
     Takes the list of GroceryListItems and adds them to the correct aisle sections. Using the
     FredMeyer.aisles list for the names and order of the aisles in the store, and
     FredMeyere.aisleDesignations to match the items name to the aisle it belongs. This list is
     built to take the first match in the list rather than the last, so loops must be exited
     once a match is found.
     */
    private func organizeItems() {
        let allItems = self.groceryListItems
        
        // Initialize empty shopping list organized by aisle
        let organizedGroceryList = FredMeyer.aisles.map { (aisle: String) -> Aisle in
            let name = aisle
            let items = Array<GroceryListItem>()
            
            guard let aisle = Aisle(name: name, items: items) else {
                fatalError("Unable to instanstiate GroceryListItem")
            }
            
            return aisle
        }
        
        allItems.forEach { (item) in
            print(item.name)
            
            //loops through all the aisledesignation key value pairs until it finds a match
            for designation in FredMeyer.aisleDesignations {
                print(designation.word)
                if item.name.lowercased().range(of: designation.word.lowercased()) != nil {
                    print("there's a match for \(item.name) in \(designation.aisle)!!")
                    // NEED TO EXIT THIS LOOP, WHICH IS IMPOSSIBLE, SO NEED TO WRITE THIS A DIFFERENT WAY
                    
                    // finds the right aisle instance to add the item into.
                    if let aisle = organizedGroceryList.first(where: { $0.name == designation.aisle }) {
                        aisle.items! += [item]
                    }
                    break
                }
            }
        }
        
        self.organizedGroceryList = organizedGroceryList
        
        self.tableView.reloadData()
    }
    
    private func filterRecipes() {
        self.filteredRecipes = self.recipes.filter({ (recipe: Recipe) -> Bool in
            return recipe.onShoppingList == true
        })
        
        print(self.recipes.count, self.filteredRecipes.count)
    }

}
