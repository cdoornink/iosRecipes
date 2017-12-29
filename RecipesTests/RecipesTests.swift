//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Chris Doornink on 12/29/17.
//  Copyright © 2017 Chris Doornink. All rights reserved.
//

import XCTest
@testable import Recipes

class RecipesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: Recipe Class Tests
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testRecipeInitializationSucceeds() {
        // Normal Case
        let zeroRatingMeal = Recipe.init(name: "Bread", photo: nil, ingredients: ["flour"], directions: ["bake"])
        XCTAssertNotNil(zeroRatingMeal)
        
    }
    
    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testRecipeInitializationFails() {
        // No name
        let negativeRatingMeal = Recipe.init(name: "", photo: nil, ingredients: ["arugula"], directions: ["bake"])
        XCTAssertNil(negativeRatingMeal)
    }
}
