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
    var manuallyAddedItems = [GroceryListItem]()
    var inputTextValue = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecipes()
        loadManuallyAddedItems()

        itemAddBar.setImage(UIImage(named: "add-to-cart-gray"), for: .search, state: .normal)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        itemAddBar.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
//        return Constants.aisles
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
    
    private func loadManuallyAddedItems() {
        
        ref = Database.database().reference()
        
        ref.child("shoppingList").observe(.value, with: { (snapshot) in
            
            var items = [GroceryListItem]()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                let item = childSnapshot.value as? [String : AnyObject] ?? [:]
                
                let name = item["title"] as! String
                let recipes = item["recipes"] as? Array<String>
                let inCart = item["inCart"] as? Bool
                
                
                guard let entry = GroceryListItem(name: name, recipes: recipes, inCart: inCart ?? false) else {
                    fatalError("Unable to instanstiate GroceryListItem")
                }
                
                items += [entry]
                
            }
            
            self.manuallyAddedItems = items
//            self.organizeItems()
            print(self.manuallyAddedItems)
        })
    }
    
    private func filterRecipes() {
        self.filteredRecipes = self.recipes.filter({ (recipe: Recipe) -> Bool in
            return recipe.onShoppingList == true
        })
        
        print(self.recipes.count, self.filteredRecipes.count)
        
        self.tableView.reloadData()
    }

}
