//
//  Recipe.swift
//  Recipes
//
//  Created by Chris Doornink on 12/29/17.
//  Copyright © 2017 Chris Doornink. All rights reserved.
//

import UIKit

class Recipe {
    
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var ingredients: Array<Dictionary<String, Any>>?
    var directions: Array<String>?
    var onShoppingList: Bool?
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, ingredients: Array<Dictionary<String, Any>>?, directions: Array<String>?, onShoppingList: Bool?) {
        
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.ingredients = ingredients
        self.directions = directions
        self.onShoppingList = onShoppingList ?? false
    }
}
