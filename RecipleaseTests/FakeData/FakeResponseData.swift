//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by David Dubez on 07/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
    static var recipeListCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "RecipeList", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var recipeListWithNoMatchCount: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "RecipeListWithNoMatch", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var recipeCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Recipe", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var WrongData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "WrongResponse", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var CorrectDataEmpty: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "EmptyResponse", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

//    static let weatherIncorrectData = "erreur".data(using: .utf8)!
//    static let imageData = "image".data(using: .utf8)!

    // MARK: - Response
//    static let responseOK = HTTPURLResponse(
//        url: URL(string: "http://goodResponse")!,
//        statusCode: 200, httpVersion: nil, headerFields: [:])!
//
//    static let responseKO = HTTPURLResponse(
//        url: URL(string: "http://badResponse")!,
//        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error
    class NetworkRequestError: Error {}
    static let error = NetworkRequestError()
}
