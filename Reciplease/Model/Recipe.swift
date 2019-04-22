//
//  Recipe.swift
//  Reciplease
//
//  Created by David Dubez on 11/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreData

class Recipe: NSManagedObject, Codable {
// creation of structure like JSON model response

    var ingredientLines: [String] = []

    enum CodingKeys: String, CodingKey {
        case recipeId = "id"
        case name, source, attribution, totalTimeInSeconds, rating, ingredientLines, images
    }

    required convenience init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedObjectContext) else {
                fatalError("Failed to decode Recipe!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        recipeId = try values.decode(String.self, forKey: .recipeId)
        source = try values.decode(Source.self, forKey: .source)
        attribution = try values.decode(Attribution.self, forKey: .attribution)
        totalTimeInSeconds = try values.decode(Int16.self, forKey: .totalTimeInSeconds)
        rating = try values.decode(Int16.self, forKey: .rating)
        
        let imageOne = try values.decode([Image].self, forKey: .images)
        images = imageOne[0]

        ingredientLines = try values.decode([String].self, forKey: .ingredientLines)

//        ingredientsLines = try values.decode(IngredientsLine.self, forKey: .ingredientsLines)
    }
}

extension Recipe {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(recipeId, forKey: .recipeId)
        try container.encode(source, forKey: .source)
        try container.encode(attribution, forKey: .attribution)
        try container.encode(totalTimeInSeconds, forKey: .totalTimeInSeconds)
        try container.encode(rating, forKey: .rating)
        try container.encode(images, forKey: .images)

 //       try container.encode(ingredientsLines, forKey: .ingredientsLines)
// TODO:    - ingredients line dans coreData
    }
}
