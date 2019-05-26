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
        // Given
        let ingredient = "Sugar"

        // When
        IngredientService.shared.add(ingredient: ingredient)

        // Then
        XCTAssertEqual(IngredientService.shared.ingredients, ["Sugar"])
    }

    func testGivenIngredientsIsSugar_WhenClearIngredient_ThenIngredientsShouldBeEmpty() {
        // Given
        let ingredient = "Sugar"
        IngredientService.shared.add(ingredient: ingredient)

        // When
        IngredientService.shared.clear()

        // Then
        XCTAssertEqual(IngredientService.shared.ingredients, [])
    }

    func testGivenIngredientsAreSugarSaltPepper_WhenRemoveAtOne_ThenIngredientsShouldBeSugarSalt() {
        // Given
        IngredientService.shared.add(ingredient: "Sugar")
        IngredientService.shared.add(ingredient: "Salt")
        IngredientService.shared.add(ingredient: "Pepper")

        // When
        IngredientService.shared.removeIngredient(at: 1)

        // Then
        XCTAssertEqual(IngredientService.shared.ingredients, ["Sugar", "Pepper"])
    }

    func testGivenIngredientsAreSugarSaltPepper_WhenSetSearchList_ThenSearchListShouldBeCorrect() {
        // Given
        IngredientService.shared.add(ingredient: "Sugar")
        IngredientService.shared.add(ingredient: "Salt")
        IngredientService.shared.add(ingredient: "Pepper")

        // When
        IngredientService.shared.setSearchList()

        // Then
        XCTAssertEqual(IngredientService.shared.searchList, "+Sugar+Salt+Pepper")
    }
}
