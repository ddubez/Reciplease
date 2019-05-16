//
//  Attribution.swift
//  Reciplease
//
//  Created by David Dubez on 21/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreData

class Attribution: NSManagedObject, Codable {
    // creation of structure like JSON model response

    enum CodingKeys: String, CodingKey {
        case attributionUrl = "url"
        case attributionHtml = "html"
        case attributionText = "text"
        case attributionLogo = "logo"
    }

    required convenience init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Attribution", in: managedObjectContext) else {
                fatalError("Failed to decode Attribution!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attributionUrl = try values.decode(String.self, forKey: .attributionUrl)
        attributionHtml = try values.decode(String.self, forKey: .attributionHtml)
        attributionText = try values.decode(String.self, forKey: .attributionText)
        attributionLogo = try values.decode(String.self, forKey: .attributionLogo)
    }
}

extension Attribution {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(attributionUrl, forKey: .attributionUrl)
        try container.encode(attributionHtml, forKey: .attributionHtml)
        try container.encode(attributionText, forKey: .attributionText)
        try container.encode(attributionLogo, forKey: .attributionLogo)
    }
}
