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
    
    var groceryListItems: Array<GroceryListItem> = []
    var controller: GroceryListTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickSuggestionOne(_ sender: Any) {
        self.clickSuggestion(suggestionOneLabel)
    }

    @IBAction func clickSuggestionTwo(_ sender: Any) {
        self.clickSuggestion(suggestionTwoLabel)
    }
    
    @IBAction func clickSuggestionThree(_ sender: Any) {
        self.clickSuggestion(suggestionThreeLabel)
    }
    
    private func clickSuggestion(_ button: UIButton) {
        let api = RecipesAPI()
        api.addItemToList(button.title(for: .normal)!, groceryListItems)
        let searchBar = (controller?.itemAddBar)!
        searchBar.text = ""
        controller?.inputTextValue = ""
        controller?.filterItemSuggestions()
    }
}
