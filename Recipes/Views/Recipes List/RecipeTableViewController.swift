//
//  RecipeTableViewController.swift
//  Recipes
//
//  Created by Chris Doornink on 12/29/17.
//  Copyright © 2017 Chris Doornink. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

class RecipeTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: Properties
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    
    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var filterTextValue = ""
    var groceryListItems = [GroceryListItem]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.setContentOffset( CGPoint(x: 0, y: 50) , animated: true)

        let recipesAPI = RecipesAPI()
        
        recipesAPI.getRecipes(callback: {(recipes: Array<Recipe>) -> Void in
            self.recipes = recipes
            self.filterRecipes()
            
            let tabBar = TabBar()
            tabBar.setGroceryListBadge(recipes, tabBarController: self.tabBarController!)
            tabBar.setMenuBadge(recipes, tabBarController: self.tabBarController!)
            
        })
        
        recipesAPI.getGroceryListItems(callback: {(groceryListItems: Array<GroceryListItem>) -> Void in
            self.groceryListItems = groceryListItems
            self.tableView.reloadData()
        })
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        recipeSearchBar.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
    
        let recipe = filteredRecipes[indexPath.row]

        cell.recipeName.text = recipe.name
        cell.recipeImage.image = recipe.photo
        cell.recipe = recipe
        cell.groceryListItems = self.groceryListItems
        
        if (recipe.onShoppingList == true) {
            let origImage = UIImage(named: "shopping-list")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            cell.addToCartButton.setImage(tintedImage, for: .normal)
            cell.addToCartButton.tintColor = Colors.blue
        } else {
            let origImage = UIImage(named: "add-to-cart")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            cell.addToCartButton.setImage(tintedImage, for: .normal)
            cell.addToCartButton.tintColor = Colors.darkBlue
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
            
            guard let selectedCell = sender as? RecipeTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRecipe = filteredRecipes[indexPath.row]
            recipeViewController.recipe = selectedRecipe
        }
    }

    // MARK: Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterTextValue = searchText
        self.filterRecipes()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filterTextValue = ""
        self.filterRecipes()
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    // MARK: Private Methods
    
    private func filterRecipes() {
        if self.filterTextValue == "" {
            self.filteredRecipes = self.recipes
        } else {
            self.filteredRecipes = self.recipes.filter({ (recipe: Recipe) -> Bool in
                return recipe.name.lowercased().range(of: self.filterTextValue.lowercased()) != nil
            })
        }
        
        print(self.recipes.count, self.filteredRecipes.count)
        
        self.tableView.reloadData()
    }

}
