//
//  RecipeImageServiceTestCase.swift
//  RecipleaseTests
//
//  Created by David Dubez on 17/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeImageServiceTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testGetImageShouldPostFailedDataIfError() {
        // Given
        let imageUrl = "https://lh3.googleusercontent.com/" +
        "oJ1g4HHQt-v-e0vsbqRgLpFvIXYgOUoMULyVQGaKTkwdyu-sSYpDvJxjtyi2NlJYFUt1NTjEmmYuuthqnQXRfw=s90"
        let fakeNetworkRequest = FakeNetwokRequest(data: nil, error: NRError.noData)
        let recipeImageService = RecipeImageService(recipeImageRequest: fakeNetworkRequest)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeImageService.getIconImage(imageUrl: imageUrl) { (data) in
            // Then
            XCTAssertNil(data)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetImageShouldPostFailedDataIfNoData() {
        // Given
        let imageUrl = "https://lh3.googleusercontent.com/" +
        "oJ1g4HHQt-v-e0vsbqRgLpFvIXYgOUoMULyVQGaKTkwdyu-sSYpDvJxjtyi2NlJYFUt1NTjEmmYuuthqnQXRfw=s90"
        let fakeNetworkRequest = FakeNetwokRequest(data: nil, error: nil)
        let recipeImageService = RecipeImageService(recipeImageRequest: fakeNetworkRequest)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeImageService.getIconImage(imageUrl: imageUrl) { (data) in
            // Then
            XCTAssertNil(data)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetImageShouldPostSuccessDataIfData() {
        // Given
        let imageUrl = "https://lh3.googleusercontent.com/" +
        "oJ1g4HHQt-v-e0vsbqRgLpFvIXYgOUoMULyVQGaKTkwdyu-sSYpDvJxjtyi2NlJYFUt1NTjEmmYuuthqnQXRfw=s90"
        let defaultPhoto = UIImage(named: "defaultPhoto")
        let imageData = defaultPhoto?.pngData()
        let fakeNetworkRequest = FakeNetwokRequest(data: imageData, error: nil)
        let recipeImageService = RecipeImageService(recipeImageRequest: fakeNetworkRequest)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeImageService.getIconImage(imageUrl: imageUrl) { (data) in
            // Then
            if let data = data {
                XCTAssertEqual(imageData, data)
            }
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetImageShouldPostSuccess() {
        // Given
        let imageUrl = "https://lh3.googleusercontent.com/" +
        "oJ1g4HHQt-v-e0vsbqRgLpFvIXYgOUoMULyVQGaKTkwdyu-sSYpDvJxjtyi2NlJYFUt1NTjEmmYuuthqnQXRfw=s90"
        let recipeImageService = RecipeImageService()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        recipeImageService.getIconImage(imageUrl: imageUrl) { (data) in
            // Then
            XCTAssertNotNil(data)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
}
