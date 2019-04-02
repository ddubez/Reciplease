//
//  RecipeList.swift
//  Reciplease
//
//  Created by David Dubez on 12/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct RecipeList: Decodable {
    // creation of structure like JSON model response

    var matches: [Matche]?

    struct Matche: Decodable {
        var sourceDisplayName: String?
        var imagesUrlsBySize: [ImageUrlsBySize]?
        var ingredients: [String]
        var referenceId: String
        var smallImageUrls: [String]?
        var recipeName: String
        var totalTimeInSeconds: Int?
        var attributes: Attribute?
        var flavors: Flavor?
        var rating: Int?
    }
    struct ImageUrlsBySize: Decodable {
        var ninety: String
    }
    struct Attribute: Decodable {
        var course: [String]?
        var cuisine: [String]?
        var holiday: [String]?
    }
    struct Flavor: Decodable {
        var salty: Double?
        var sour: Double?
        var sweet: Double?
        var bitter: Double?
        var meaty: Double?
        var piquant: Double?
    }
}

extension RecipeList.ImageUrlsBySize {
    enum CodingKeys: String, CodingKey {
        case ninety = "90"
    }
}
extension RecipeList.Matche {
    enum CodingKeys: String, CodingKey {
        case ingredients, smallImageUrls, recipeName, totalTimeInSeconds, rating
        case referenceId = "id"
    }
}