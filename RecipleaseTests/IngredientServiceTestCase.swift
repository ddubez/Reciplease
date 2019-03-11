//
//  IngredientServiceTestCase.swift
//  RecipleaseTests
//
//  Created by David Dubez on 11/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Reciplease

class IngredientServiceTestCase: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenIngredientsIsEmpty_WhenAddIngredientSugar_ThenIngredientsShouldBeSugar() {
        let ingredient = "Sugar"

        IngredientService.shared.add(ingredient: ingredient)

        XCTAssertEqual(IngredientService.shared.ingredients, ["Sugar"])
    }

    func testGivenIngredientsIsSugar_WhenClearIngredient_ThenIngredientsShouldBeEmpty() {
        let ingredient = "Sugar"
        IngredientService.shared.add(ingredient: ingredient)

        IngredientService.shared.clear()

        XCTAssertEqual(IngredientService.shared.ingredients, [])
    }
}
