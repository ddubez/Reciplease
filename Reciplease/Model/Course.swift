//
//  Course.swift
//  Reciplease
//
//  Created by David Dubez on 12/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreData

class Course: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case name
    }

    required convenience init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Course", in: managedObjectContext) else {
                fatalError("Failed to decode Course!")
        }
        self.init(entity: entity, insertInto: nil)

        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
    }
}

extension Course {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}
