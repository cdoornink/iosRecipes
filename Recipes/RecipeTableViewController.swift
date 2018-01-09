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
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        loadSampleRecipes()
        self.loadRecipes()
        
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
    
        let recipe = filteredRecipes[indexPath.row]

        cell.recipeName.text = recipe.name
        cell.recipeImage.image = recipe.photo
        
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
        self.filterTextValue = ""
        self.filterRecipes()
        searchBar.endEditing(true)
    }
    
    
    
    

    
    // MARK: Private Methods
    
//    private func loadSampleRecipes() {
//        let photo1 = UIImage(named: "chicken-casserole")
//        let photo2 = UIImage(named: "golden-coconut-lentil-soup")
//
//        guard let recipe1 = Recipe(name: "Something yummy with Chicken", photo: photo1, ingredients: [["name":"pasta", "amount": "1 tsp"], ["name":"chicken"]], directions: ["cook the damn thing"]) else {
//            fatalError("Unable to instanstiate recipe1")
//        }
//
//        guard let recipe2 = Recipe(name: "Pork Sammy", photo: photo2, ingredients: [["name":"pasta", "amount": "1 tsp"], ["name":"chicken"]], directions: ["put them together"]) else {
//            fatalError("Unable to instanstiate recipe2")
//        }
//
//        recipes += [recipe1, recipe2]
//
//    }
    
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
