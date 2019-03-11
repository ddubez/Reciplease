//
//  IngredientService.swift
//  Reciplease
//
//  Created by David Dubez on 11/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class IngredientService {
    static let shared = IngredientService()
    private init() {}

    private(set) var ingredients: [String] = []

    func add(ingredient: String) {
        ingredients.append(ingredient)
    }
    func clear() {
        ingredients = []
    }
}
