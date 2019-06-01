//
//  RecipeService.swift
//  Reciplease
//
//  Created by David Dubez on 11/03/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Alamofire

class RecipeService {
    // network request for retrieve recipe data in Recipe Class

    // MARK: - PROPERTIES
    private static let getRecipeBaseUrlString = "https://api.yummly.com/v1/api/recipe/"

    static var shared = RecipeService()
    private init() {}

    private var recipeRequest: NetworkRequest = AlamofireNetworkRequest()
    init(recipeRequest: NetworkRequest) {
        self.recipeRequest = recipeRequest
    }

    private static var recipeUrlParameters: Parameters = [
            "_app_key": ServicesKey.yummlyApiKey,
            "_app_id": ServicesKey.yummlyApiId
            ]

    // MARK: - FUNCTIONS
    /**
     Request to get a recipe with the id of the recipe
     - Parameter recipeId: string of the id
     - Parameter callBack: A bool for success, the Recipe and an error
     */
    func getRecipe(recipeId: String, callBack: @escaping (Bool, Recipe?, Error?) -> Void) {
        let getRecipeUrlString = RecipeService.getRecipeBaseUrlString + recipeId

        recipeRequest.get(url: getRecipeUrlString,
                          parameters: RecipeService.recipeUrlParameters) { (recipeGetted: Recipe?, error) in
            if let error = error {
                callBack(false, nil, error)
                return
            }
            guard let recipe = recipeGetted else {
                callBack(false, nil, RSError.noRecipe)
                return
            }
            callBack(true, recipe, nil)
        }
    }
}

extension RecipeService {
    /**
     'RSError' is the error type returned by RecipeService.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     
     - noRecipe: return when there is no recipe return in get request
     */
    enum RSError: Error {
        case noRecipe
    }
}
