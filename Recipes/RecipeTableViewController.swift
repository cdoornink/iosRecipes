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

class RecipeTableViewController: UITableViewController {

    // MARK: Properties
    
    var recipes = [Recipe]()
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        loadSampleRecipes()
        self.loadRecipes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
    
        let recipe = recipes[indexPath.row]

        cell.recipeName.text = recipe.name
        cell.recipeImage.image = recipe.photo
        
        return cell
    }

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
            
            let selectedRecipe = recipes[indexPath.row]
            recipeViewController.recipe = selectedRecipe
        }
    }

    
    // MARK: Private Methods
    
    private func loadSampleRecipes() {
        let photo1 = UIImage(named: "chicken-casserole")
        let photo2 = UIImage(named: "golden-coconut-lentil-soup")

        guard let recipe1 = Recipe(name: "Something yummy with Chicken", photo: photo1, ingredients: [["name":"pasta", "amount": "1 tsp"], ["name":"chicken"]], directions: ["cook the damn thing"]) else {
            fatalError("Unable to instanstiate recipe1")
        }
        
        guard let recipe2 = Recipe(name: "Pork Sammy", photo: photo2, ingredients: [["name":"pasta", "amount": "1 tsp"], ["name":"chicken"]], directions: ["put them together"]) else {
            fatalError("Unable to instanstiate recipe2")
        }
        
        recipes += [recipe1, recipe2]
        
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
                
                guard let entry = Recipe(name: recipeName, photo: photo, ingredients: ingredients, directions: directions) else {
                    fatalError("Unable to instanstiate recipe")
                }
                
                recipes += [entry]
                
            }
            
            self.recipes = recipes
            self.tableView.reloadData()
        })
    }


}
