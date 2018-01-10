//
//  IngredientTableViewCell.swift
//  Recipes
//
//  Created by Chris Doornink on 1/4/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var ingredientAmountLabel: UILabel!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
