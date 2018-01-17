//
//  MenuTableViewController.swift
//  Recipes
//
//  Created by Chris Doornink on 1/12/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

class MenuTableViewController: UITableViewController {

    var recipes = [Recipe]()
    var uncookedRecipes = [Recipe]()
    var cookedRecipes = [Recipe]()
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recipesAPI = RecipesAPI()
        
        recipesAPI.getRecipes(callback: {(recipes: Array<Recipe>) -> Void in
            self.recipes = recipes
            self.organizeRecipes()
        })
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return uncookedRecipes.count
        }
        return cookedRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ready to cook"
        }
        
        return "Finished"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
        
        let recipe = indexPath.section == 0 ? uncookedRecipes[indexPath.row] : cookedRecipes[indexPath.row]
        
        cell.recipeName.text = recipe.name
        cell.recipeImage.image = recipe.photo
        cell.recipe = recipe
        
        if (recipe.isCooked == true) {
            let origImage = UIImage(named: "check")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            cell.isCookedButton.setImage(tintedImage, for: .normal)
            cell.isCookedButton.tintColor = UIColor.lightGray
            
        } else {
            let origImage = UIImage(named: "fork-and-knife")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            cell.isCookedButton.setImage(tintedImage, for: .normal)
            cell.isCookedButton.tintColor = Colors.blue
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
            
            guard let selectedCell = sender as? MenuTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRecipe = indexPath.section == 0 ? uncookedRecipes[indexPath.row] : cookedRecipes[indexPath.row]
            recipeViewController.recipe = selectedRecipe
        }
    }
    
    // MARK: Private Methods
    
    private func organizeRecipes() {
        self.uncookedRecipes = self.recipes.filter({ (recipe: Recipe) -> Bool in
            return recipe.onMenu == true && recipe.isCooked == false
        })
        
        self.cookedRecipes = self.recipes.filter({ (recipe: Recipe) -> Bool in
            return recipe.onMenu == true && recipe.isCooked == true
        })
        
        self.tableView.reloadData()
    }
}

