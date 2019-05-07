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

    func testGetRecipeListServiceShouldPostSuccessCallback() {
        // Given
        let searchPhrase = "onion+egg+butter+milk"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        RecipeListService.shared.getRecipeList(searchPhrase:
        searchPhrase, start: 0) {(success, recipeListMatches, numberOfResult, error) in

            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(error, "")

//            let qCriteria = "onion egg butter milk"

//            XCTAssertEqual(qCriteria, recipe)
            XCTAssert(numberOfResult! > 0)
            XCTAssertNotNil(recipeListMatches)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }

}
// TODO: - Verifier les différents cas d'erreur et voir leur bon affichage
