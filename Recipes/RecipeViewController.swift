//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Chris Doornink on 12/29/17.
//  Copyright © 2017 Chris Doornink. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let recipe = recipe {
            recipeName.text = recipe.name
            recipeImage.image = recipe.photo
        }
    }


}

