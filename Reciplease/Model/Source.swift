//
//  Source.swift
//  Reciplease
//
//  Created by David Dubez on 21/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreData

class Source: NSManagedObject, Codable {
    // creation of structure like JSON model response

    enum CodingKeys: String, CodingKey {
        case sourceDisplayName, sourceRecipeUrl, sourceSiteUrl
    }

    required convenience init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Source", in: managedObjectContext) else {
                fatalError("Failed to decode Source!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourceDisplayName = try values.decode(String.self, forKey: .sourceDisplayName)
        sourceRecipeUrl = try values.decode(String.self, forKey: .sourceRecipeUrl)
        sourceSiteUrl = try values.decode(String.self, forKey: .sourceSiteUrl)

    }
}

extension Source {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sourceDisplayName, forKey: .sourceDisplayName)
        try container.encode(sourceRecipeUrl, forKey: .sourceRecipeUrl)
        try container.encode(sourceSiteUrl, forKey: .sourceSiteUrl)

    }
}
