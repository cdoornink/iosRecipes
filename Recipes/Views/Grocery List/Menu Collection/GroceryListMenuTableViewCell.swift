//
//  GroceryListMenuTableViewCell.swift
//  Recipes
//
//  Created by Chris Doornink on 1/11/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class GroceryListMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    weak var recipe: Recipe?
    var groceryListItems: [GroceryListItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func removeFromCartButtonClick(_ sender: UIButton) {
        let api = RecipesAPI()
        
        if (recipe?.onShoppingList == true) {
            api.removeRecipeFromList(recipe!, groceryListItems)
        } else {
            api.addRecipeToList(recipe!, groceryListItems)
        }
    }
}
