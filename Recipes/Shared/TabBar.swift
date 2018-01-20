//
//  TabBar.swift
//  Recipes
//
//  Created by Chris Doornink on 1/18/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

struct TabBar {
    func setGroceryListBadge(_ recipes: [Recipe], tabBarController: UITabBarController ) {
        let recipesOnList = recipes.filter { (recipe) -> Bool in
            return recipe.onShoppingList == true
        }
        if recipesOnList.count != 0 {
            if #available(iOS 10.0, *) {
                tabBarController.tabBar.items?[1].badgeColor = Colors.blue
            }
            tabBarController.tabBar.items?[1].badgeValue = "\(recipesOnList.count)"
        } else {
            tabBarController.tabBar.items?[1].badgeValue = nil
        }
        
    }

    
    func setMenuBadge(_ recipes: [Recipe], tabBarController: UITabBarController ) {
        let recipesOnList = recipes.filter { (recipe) -> Bool in
            return recipe.onMenu == true && recipe.isCooked == false
        }
        if recipesOnList.count != 0 {
            if #available(iOS 10.0, *) {
                tabBarController.tabBar.items?[2].badgeColor = Colors.blue
            }
            tabBarController.tabBar.items?[2].badgeValue = "\(recipesOnList.count)"
        } else {
            tabBarController.tabBar.items?[2].badgeValue = nil
        }
        
    }
}
