//
//  MenuTableViewCell.swift
//  Recipes
//
//  Created by Chris Doornink on 1/12/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var isCookedButton: UIButton!
    
    weak var recipe: Recipe?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func isCookedButtonClick(_ sender: Any) {
        let api = RecipesAPI()
        api.toggleRecipeIsCooked(recipe!)
    }
}
