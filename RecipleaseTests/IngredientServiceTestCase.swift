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
        super.setUp()
        IngredientService.shared.clear()
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

    func testGivenIngredientsAreSugarSaltPepper_WhenRemoveAtOne_ThenIngredientsShouldBeSugarSalt() {
        IngredientService.shared.add(ingredient: "Sugar")
        IngredientService.shared.add(ingredient: "Salt")
        IngredientService.shared.add(ingredient: "Pepper")

        IngredientService.shared.removeIngredient(at: 1)

        XCTAssertEqual(IngredientService.shared.ingredients, ["Sugar", "Pepper"])
    }

    func testGivenIngredientsAreSugarSaltPepper_WhenSetSearchList_ThenSearchListShouldBeCorrect() {
        IngredientService.shared.add(ingredient: "Sugar")
        IngredientService.shared.add(ingredient: "Salt")
        IngredientService.shared.add(ingredient: "Pepper")

        IngredientService.shared.setSearchList()

        XCTAssertEqual(IngredientService.shared.searchList, "+Sugar+Salt+Pepper")
    }
}
