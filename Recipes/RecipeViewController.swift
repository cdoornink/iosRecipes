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
    @IBOutlet var scrollContentView: UIView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let recipe = recipe {
            recipeName.text = recipe.name
            recipeImage.image = recipe.photo
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipe!.directions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionTableViewCell", for: indexPath) as? DirectionTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
        
        let direction = recipe!.directions![indexPath.row]
        
        cell.directionText.text = direction
        
        DirectionsTableView.frame.size.height = DirectionsTableView.contentSize.height + 100
        
        return cell
    }


}

