//
//  RecipeListServiceTestCase.swift
//  RecipleaseTests
//
//  Created by David Dubez on 06/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest

@testable import Reciplease

class RecipeListServiceTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testGetRecipeListShouldPostFailedCallbackIfError() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: nil, error: NRError.noData)
        let recipeListService = RecipeListService(recipeListRequest: fakeNetworkRequest)
        let searchPhrase = "lemon+salad"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeListService.getRecipeList(searchPhrase: searchPhrase,
                                               start: 0) {(success, recipeListMatches, numberOfResult, error) in

            // Then
            XCTAssertFalse(success)
            XCTAssertNil(recipeListMatches)
            XCTAssertNil(numberOfResult)
            if let error = error {
                XCTAssertEqual(error.message, "There is no data in the API response !")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeListShouldPostFailedCallbackIfNoReciupeListReturn() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: nil, error: nil)
        let recipeListService = RecipeListService(recipeListRequest: fakeNetworkRequest)
        let searchPhrase = "lemon+salad"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeListService.getRecipeList(searchPhrase: searchPhrase,
                                        start: 0) {(success, recipeListMatches, numberOfResult, error) in

                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(recipeListMatches)
                                            XCTAssertNil(numberOfResult)
                                            if let error = error {
                                                XCTAssertEqual(error.message,
                                                               "There is no list of recipe in the API response !")
                                            }
                                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeListShouldPostFailedCallbackIfNoMatchInRecipListReturn() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: FakeResponseData.CorrectDataEmpty, error: nil)
        let recipeListService = RecipeListService(recipeListRequest: fakeNetworkRequest)
        let searchPhrase = "lemon+salad"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeListService.getRecipeList(searchPhrase: searchPhrase,
                                        start: 0) {(success, recipeListMatches, numberOfResult, error) in

                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(recipeListMatches)
                                            XCTAssertNil(numberOfResult)
                                            if let error = error {
                                                XCTAssertEqual(
                                                    error.message,
                                                    "There is no match in the list of recipe of the API response !")
                                            }
                                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeListShouldPostFailedCallbackIfWrongDataReturn() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: FakeResponseData.WrongData, error: nil)
        let recipeListService = RecipeListService(recipeListRequest: fakeNetworkRequest)
        let searchPhrase = "lemon+salad"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeListService.getRecipeList(searchPhrase: searchPhrase,
                                        start: 0) {(success, recipeListMatches, numberOfResult, error) in

                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(recipeListMatches)
                                            XCTAssertNil(numberOfResult)
                                            if let error = error {
                                                XCTAssertEqual(error.message,
                                                               "Error !")
                                            }
                                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeListShouldPostFailedIfRecipeListCorrectDataWithNoTotalMatchCount() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: FakeResponseData.recipeListWithNoMatchCount, error: nil)
        let recipeListService = RecipeListService(recipeListRequest: fakeNetworkRequest)
        let searchPhrase = "lemon+salad"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeListService.getRecipeList(searchPhrase: searchPhrase,
                                        start: 0) {(success, recipeListMatches, numberOfResult, error) in

                                            // Then
                                            XCTAssertFalse(success)
                                            XCTAssertNil(recipeListMatches)
                                            XCTAssertNil(numberOfResult)
                                            if let error = error {
                                                XCTAssertEqual(error.message,
                                                "There is no match count in the list of recipe of the API response !")
                                            }

                                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeListShouldPostSuccessIfRecipeListCorrectData() {
        // Given
        let fakeNetworkRequest = FakeNetwokRequest(data: FakeResponseData.recipeListCorrectData, error: nil)
        let recipeListService = RecipeListService(recipeListRequest: fakeNetworkRequest)
        let searchPhrase = "lemon+salad"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeListService.getRecipeList(searchPhrase: searchPhrase,
                                        start: 0) {(success, recipeListMatches, numberOfResult, error) in

                                            // Then
                                            XCTAssertTrue(success)
                                            XCTAssertNil(error)
                                            XCTAssertEqual(numberOfResult, 11584)
                                            XCTAssertEqual(recipeListMatches?[0].recipeName, "The Famous KFC Coleslaw")
                                            XCTAssertEqual(recipeListMatches?[0].ingredients, [
                                                "onion",
                                                "sugar",
                                                "mayonnaise",
                                                "buttermilk",
                                                "whole milk",
                                                "white vinegar",
                                                "fresh lemon juice",
                                                "salt",
                                                "black pepper",
                                                "coleslaw mix"
                                                ])
                                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeListShouldPostSuccessCallback() {
        // Given
        let searchPhrase = "onion+egg+butter+milk"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        RecipeListService.shared.getRecipeList(searchPhrase:
        searchPhrase, start: 0) {(success, recipeListMatches, numberOfResult, error) in

            // Then
            XCTAssertTrue(success)
            XCTAssertTrue(error == nil)
            XCTAssert(numberOfResult! > 0)
            XCTAssertNotNil(recipeListMatches)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
}
