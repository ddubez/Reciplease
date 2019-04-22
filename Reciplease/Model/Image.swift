//
//  Image.swift
//  Reciplease
//
//  Created by David Dubez on 22/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreData

class Image: NSManagedObject, Codable {
    // creation of structure like JSON model response

    enum CodingKeys: String, CodingKey {
        case hostedSmallUrl, hostedMediumUrl, hostedLargeUrl

    }

    required convenience init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Image", in: managedObjectContext) else {
                fatalError("Failed to decode Image!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hostedSmallUrl = try values.decode(String.self, forKey: .hostedSmallUrl)
        hostedMediumUrl = try values.decode(String.self, forKey: .hostedMediumUrl)
        hostedLargeUrl = try values.decode(String.self, forKey: .hostedLargeUrl)
    }
}

extension Image {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hostedSmallUrl, forKey: .hostedSmallUrl)
        try container.encode(hostedMediumUrl, forKey: .hostedMediumUrl)
        try container.encode(hostedLargeUrl, forKey: .hostedLargeUrl)
    }
}
