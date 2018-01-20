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
    var cookedCount: Int?
    var prepTime: Int?
    var cookTime: Int?
    var serves: Int?
    var lastCooked: Date?
    var cocktail: Bool?
    var dessert: Bool?
    var firebaseRef: String
    
    // MARK: Initialization
    
    init?(name: String, shortName: String, photo: UIImage?, ingredients: Array<Dictionary<String, Any>>?, directions: Array<String>?, onShoppingList: Bool?, onMenu: Bool?, isCooked: Bool?, cookedCount: Int?, prepTime: Int?, cookTime: Int?, serves: Int?, lastCooked: Date?, cocktail: Bool?, dessert: Bool?, firebaseRef: String) {
        
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
        self.cookedCount = cookedCount ?? 0
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.serves = serves
        self.lastCooked = lastCooked
        self.cocktail = cocktail ?? false
        self.dessert = dessert ?? false
        self.firebaseRef = firebaseRef
    }
}
