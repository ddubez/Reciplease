//
//  RecipeServiceTestCase.swift
//  RecipleaseTests
//
//  Created by David Dubez on 17/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeServiceTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testGetRecipeShouldPostFailedCallbackIfError() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: nil, error: NRError.noData)
        let recipeService = RecipeService(recipeRequest: fakeNetworkRequest)
        let recipeId = "Southern-Hush-Puppies-2583358"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeService.getRecipe(recipeId: recipeId) {(success, recipe, error) in

                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(recipe)
                                            if let error = error {
                                                XCTAssertEqual(error.message, "There is no data in the API response !")
                                            }
                                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

 func testGetRecipeShouldPostFailedCallbackIfNoReciupeReturn() {
    // Given
    let fakeNetworkRequest = FakeNetwokRequest(data: nil, error: nil)
    let recipeService = RecipeService(recipeRequest: fakeNetworkRequest)
    let recipeId = "Southern-Hush-Puppies-2583358"

    // When
    let expectation = XCTestExpectation(description: "Wait for queue change.")

    recipeService.getRecipe(recipeId: recipeId) {(success, recipe, error) in

        // Then
        XCTAssertFalse(success)
        XCTAssertNil(recipe)
        if let error = error {
            XCTAssertEqual(error.message, "There is no recipe in the API response !")
        }
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeShouldPostSuccessIfRecipeCorrectData() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: FakeResponseData.recipeCorrectData, error: nil)
        let recipeService = RecipeService(recipeRequest: fakeNetworkRequest)
        let recipeId = "Southern-Hush-Puppies-2583358"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeService.getRecipe(recipeId: recipeId) {(success, recipe, error) in

                                            // Then
                                            XCTAssertTrue(success)
                                            XCTAssertNil(error)

                                            XCTAssertEqual(recipe?.totalTimeInSeconds, 2100)
                                            XCTAssertEqual(recipe?.name, "Southern Hush Puppies")
                                            XCTAssertEqual(recipe?.source?.sourceRecipeUrl,
                                                           "https://pudgefactor.com/southern-hush-puppies/")
                                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeShouldPostSuccessCallback() {
        // Given
        let recipeId = "Southern-Hush-Puppies-2583358"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        RecipeService.shared.getRecipe(recipeId: recipeId) {(success, recipe, error) in

            // Then
            XCTAssertTrue(success)
            XCTAssertTrue(error == nil)
            XCTAssertNotNil(recipe)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
}
