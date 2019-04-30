//
//  RecipeList.swift
//  Reciplease
//
//  Created by David Dubez on 12/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import UIKit

class RecipeList: Codable {
    // creation of structure like JSON model response

    // MARK: - PROPERTIES
    var totalMatchCount: Int?
    var matches: [Matche]?

    struct Matche: Codable {
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
        var listImage: UIImage?
    }
    struct ImageUrlsBySize: Codable {
        var ninety: String
    }
    struct Attribute: Codable {
        var course: [String]?
        var cuisine: [String]?
        var holiday: [String]?
    }
    struct Flavor: Codable {
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
