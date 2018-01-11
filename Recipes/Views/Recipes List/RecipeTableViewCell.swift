//
//  RecipeTableViewCell.swift
//  Recipes
//
//  Created by Chris Doornink on 12/29/17.
//  Copyright © 2017 Chris Doornink. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    weak var recipe: Recipe?
    var groceryListItems: [GroceryListItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageContainerView.layer.shadowOpacity = 0.7
        imageContainerView.layer.shadowRadius = 5.0
        imageContainerView.layer.shadowColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addToCartButtonClick(_ sender: Any) {
        let api = RecipesAPI()
        
        if (recipe?.onShoppingList == true) {
            api.removeRecipeFromList(recipe!, groceryListItems)
        } else {
            api.addRecipeToList(recipe!, groceryListItems)
        }

    }
    
}
