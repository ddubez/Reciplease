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

    enum CodingKeys: String, CodingKey {
        case bitter, image, meaty, name, piquant, rating, salty, smallImage
        case sour, sourceDisplayName, sweet, totalTime, courses, cuisine, holidays, ingredients
        case recipeId = "id"
    }

    required convenience init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedObjectContext) else {
                fatalError("Failed to decode Recipe!")
        }
        self.init(entity: entity, insertInto: nil)

        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bitter = try values.decode(Double.self, forKey: .bitter)
        image = try values.decode(Data.self, forKey: .image)
        meaty = try values.decode(Double.self, forKey: .meaty)
        name = try values.decode(String.self, forKey: .name)
        piquant = try values.decode(Double.self, forKey: .piquant)
        rating = try values.decode(Int16.self, forKey: .rating)
        recipeId = try values.decode(String.self, forKey: .recipeId)
        salty = try values.decode(Double.self, forKey: .salty)
        smallImage = try values.decode(Data.self, forKey: .smallImage)
        sour = try values.decode(Double.self, forKey: .sour)
        sourceDisplayName = try values.decode(String.self, forKey: .sourceDisplayName)
        sweet = try values.decode(Double.self, forKey: .sweet)
        totalTime = try values.decode(Int16.self, forKey: .totalTime)

// TODO: Pourquoi problème sur encode avec NSSET
//        courses = try values.decode(Set.self, forKey: .courses)
//        cuisine = try values.decode(String.self, forKey: .cuisine)
//        holidays = try values.decode(String.self, forKey: .holidays)
//        ingredients = try values.decode(String.self, forKey: .ingredients)
    }

}

extension Recipe {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bitter, forKey: .bitter)
        try container.encode(recipeId, forKey: .recipeId)
        try container.encode(image, forKey: .image)
        try container.encode(meaty, forKey: .meaty)
        try container.encode(name, forKey: .name)
        try container.encode(piquant, forKey: .piquant)
        try container.encode(rating, forKey: .rating)
        try container.encode(salty, forKey: .salty)
        try container.encode(smallImage, forKey: .smallImage)
        try container.encode(sour, forKey: .sour)
        try container.encode(sourceDisplayName, forKey: .sourceDisplayName)
        try container.encode(sweet, forKey: .sweet)
        try container.encode(totalTime, forKey: .totalTime)

// TODO: Pourquoi problème sur encode avec NSSET
//        try container.encode(courses, forKey: .courses)
//        try container.encode(cuisine, forKey: .cuisine)
//        try container.encode(holidays, forKey: .holidays)
//        try container.encode(ingredients, forKey: .ingredients)
    }
}
