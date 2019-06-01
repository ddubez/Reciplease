//
//  CodingUserInfoKey+Extension.swift
//  Reciplease
//
//  Created by David Dubez on 11/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

// add a key to pass the context of NSManagedObject
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
