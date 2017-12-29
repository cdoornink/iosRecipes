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
    var ingredients: Array<String>?
    var directions: Array<String>?
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, ingredients: Array<String>?, directions: Array<String>?) {
        
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.ingredients = ingredients
        self.directions = directions
    }
}
