//
//  GroceryListMenuTableViewController.swift
//  Recipes
//
//  Created by Chris Doornink on 1/11/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

class GroceryListMenuTableViewController: UITableViewController {
    
    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var groceryListItems = [GroceryListItem]()
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recipesAPI = RecipesAPI()
        
        recipesAPI.getRecipes(callback: {(recipes: Array<Recipe>) -> Void in
            self.recipes = recipes
            self.filterRecipes()
        })
        
        recipesAPI.getGroceryListItems(callback: {(groceryListItems: Array<GroceryListItem>) -> Void in
            self.groceryListItems = groceryListItems
            self.tableView.reloadData()
        })
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListMenuTableViewCell", for: indexPath) as? GroceryListMenuTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
        
        let recipe = filteredRecipes[indexPath.row]
        
        cell.name.text = recipe.name
        cell.recipeImage.image = recipe.photo
        cell.recipe = recipe
        cell.groceryListItems = self.groceryListItems
        
        if (recipe.onShoppingList == true) {
            let origImage = UIImage(named: "shopping-list")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            cell.addToCartButton.setImage(tintedImage, for: .normal)
            cell.addToCartButton.tintColor = UIColor(red:0.00, green:0.56, blue:0.03, alpha:1.0)
        } else {
            cell.addToCartButton.setImage(UIImage(named: "add-to-cart"), for: .normal)
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // gets the selected recipe item and passes it through to the RecipeViewController
        if segue.identifier == "ShowDetail" {
            guard let recipeViewController = segue.destination as? RecipeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? GroceryListMenuTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRecipe = filteredRecipes[indexPath.row]
            recipeViewController.recipe = selectedRecipe
        }
    }
    
    // MARK: Private Methods
    
    private func filterRecipes() {
        self.filteredRecipes = self.recipes.filter({ (recipe: Recipe) -> Bool in
            return recipe.onShoppingList == true
        })
        
        self.tableView.reloadData()
    }
}
