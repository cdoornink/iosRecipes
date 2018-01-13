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
    var shortName: String
    var photo: UIImage?
    var ingredients: Array<Dictionary<String, Any>>?
    var directions: Array<String>?
    var onShoppingList: Bool?
    var onMenu: Bool?
    var isCooked: Bool?
    var firebaseRef: String
    
    // MARK: Initialization
    
    init?(name: String, shortName: String, photo: UIImage?, ingredients: Array<Dictionary<String, Any>>?, directions: Array<String>?, onShoppingList: Bool?, onMenu: Bool?, isCooked: Bool?, firebaseRef: String) {
        
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.shortName = shortName
        self.photo = photo
        self.ingredients = ingredients
        self.directions = directions
        self.onShoppingList = onShoppingList ?? false
        self.onMenu = onMenu ?? false
        self.isCooked = isCooked ?? false
        self.firebaseRef = firebaseRef
    }
}
