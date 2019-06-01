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
        var ingredients: [String]
        var referenceId: String
        var smallImageUrls: [String]?
        var recipeName: String
        var totalTimeInSeconds: Int?
        var rating: Int?
        var listImage: UIImage?
    }
}

extension RecipeList.Matche {
    enum CodingKeys: String, CodingKey {
        case ingredients, smallImageUrls, recipeName, totalTimeInSeconds, rating
        case referenceId = "id"
    }
}

extension RecipeList.Matche {
    init?(with recipe: Recipe) {
        //init a RecipeList.Matche with a Recipe instance
        guard let recipeId = recipe.recipeId,
            let recipeName = recipe.name else {
                return nil
        }
        self.sourceDisplayName =  recipe.source?.sourceDisplayName

        if let recipeIngredientLines = recipe.ingredientLines {
            self.ingredients = []
            for index in 0...(recipeIngredientLines.count - 1) {
                if let ingredientLine = recipeIngredientLines.object(at: index) as? IngredientLine {
                    if let ingredient = ingredientLine.line {
                        self.ingredients.append(ingredient)
                    }
                }
            }
        } else {
            self.ingredients = ["no ingredient"]
        }
        referenceId = recipeId

        smallImageUrls = [recipe.images?.hostedSmallUrl] as? [String]
        self.recipeName = recipeName
        totalTimeInSeconds = Int(recipe.totalTimeInSeconds)
        rating = Int(recipe.rating)
        if let recipeImageForList = recipe.imageForList {
            listImage = UIImage(data: recipeImageForList)
        } else {
            listImage = nil
        }
    }
}
