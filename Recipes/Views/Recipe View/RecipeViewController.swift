//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Chris Doornink on 12/29/17.
//  Copyright © 2017 Chris Doornink. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var DirectionsTableView: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet var scrollContentView: UIView!
    @IBOutlet weak var ingredientTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var directionTableHeightConstraint: NSLayoutConstraint!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let recipe = recipe {
            recipeName.text = recipe.name
            recipeImage.image = recipe.photo
        }
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = recipeImage.frame
//        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
//        gradient.locations = [0.5, 1.0]
//        recipeImage.layer.insertSublayer(gradient, at: 0)
        
    }

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == ingredientsTableView {
            count = recipe!.ingredients!.count //CHANGE THIS!!!!
        }
        
        if tableView == DirectionsTableView {
            count = recipe!.directions!.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?

        if tableView == ingredientsTableView {
            guard let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as? IngredientTableViewCell else {
                fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
            }
            let rowData = recipe!.ingredients![indexPath.row]
            
            if let name = rowData["name"] as! String? {
                ingredientCell.ingredientNameLabel.text = name
            } else {
                ingredientCell.ingredientNameLabel.text = ":"
            }
            
            if let amount = rowData["amount"] as! String? {
                ingredientCell.ingredientAmountLabel.text = amount
            } else if let section = rowData["section"] as! String? {
                ingredientCell.ingredientAmountLabel.text = section
            } else {
                ingredientCell.ingredientAmountLabel.text = ""
            }
            
            
            ingredientTableHeightConstraint.constant = tableView.contentSize.height
            
            cell = ingredientCell
        }
        
        if tableView == DirectionsTableView {
            guard let directionCell = tableView.dequeueReusableCell(withIdentifier: "DirectionTableViewCell", for: indexPath) as? DirectionTableViewCell else {
                fatalError("The dequeued cell is not an instance of DirectionTableViewCell.")
            }
            
            let direction = recipe!.directions![indexPath.row]
            
            directionCell.directionText.text = direction
            
            directionTableHeightConstraint.constant = tableView.contentSize.height + 100
            
            cell = directionCell
        }
        
        return cell!
    }


}

