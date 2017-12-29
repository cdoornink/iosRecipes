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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
