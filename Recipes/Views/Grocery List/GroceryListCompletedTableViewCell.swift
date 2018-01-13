//
//  GroceryListCompletedTableViewCell.swift
//  Recipes
//
//  Created by Chris Doornink on 1/12/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class GroceryListCompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var finishedShoppingButton: UIButton!
    
    var recipes: [Recipe] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func finishedShoppingButtonClick(_ sender: Any) {
        let api = RecipesAPI()
        api.clearShoppingListAndReplaceMenu(recipes)
    }
    
}
