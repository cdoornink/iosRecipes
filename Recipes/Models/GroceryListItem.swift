//
//  GroceryListItem.swift
//  Recipes
//
//  Created by Chris Doornink on 1/8/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

class GroceryListItem {
    
    // MARK: Properties
    
    var name: String
    var recipes: Array<String>?
    var manuallyAdded: Bool
    var inCart: Bool
    var firebaseRef: String
    
    // MARK: Initialization
    
    init?(name: String, recipes: Array<String>?, manuallyAdded: Bool, inCart: Bool, firebaseRef: String) {
        
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.recipes = recipes
        self.manuallyAdded = manuallyAdded
        self.inCart = inCart
        self.firebaseRef = firebaseRef
    }
}
