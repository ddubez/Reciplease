//
//  IngredientLine.swift
//  Reciplease
//
//  Created by David Dubez on 29/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreData

class IngredientLine: NSManagedObject, Codable {

    // creation of structure like JSON model response

    enum CodingKeys: String, CodingKey {
        case line = ""
    }

    required convenience init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "IngredientLine", in: managedObjectContext) else {
                fatalError("Failed to decode IngredientLines!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)

        line = try values.decode(String?.self, forKey: .line)
    }
}

extension IngredientLine {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(line, forKey: .line)

    }
}
