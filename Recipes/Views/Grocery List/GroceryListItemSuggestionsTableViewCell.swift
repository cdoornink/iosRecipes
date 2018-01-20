//
//  GroceryListItemSuggestionsTableViewCell.swift
//  Recipes
//
//  Created by Chris Doornink on 1/18/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class GroceryListItemSuggestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var suggestionOneLabel: UIButton!
    @IBOutlet weak var suggestionTwoLabel: UIButton!
    @IBOutlet weak var suggestionThreeLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
