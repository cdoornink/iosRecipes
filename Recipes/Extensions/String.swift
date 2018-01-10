//
//  String.swift
//  Recipes
//
//  Created by Chris Doornink on 1/10/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizeFirstLetter()
    }
}
