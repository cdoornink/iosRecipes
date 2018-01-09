//
//  Aisle.swift
//  Recipes
//
//  Created by Chris Doornink on 1/8/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class Aisle {

    // MARK: Properties
    
    var name: String
    var items: Array<GroceryListItem>?
    
    // MARK: Initialization
    
    init?(name: String, items: Array<GroceryListItem>?) {
        
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.items = items
    }
}
