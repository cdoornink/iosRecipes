//
//  DirectionTableViewCell.swift
//  Recipes
//
//  Created by Chris Doornink on 1/3/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var directionText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
