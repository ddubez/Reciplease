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

    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
    static var shared = RecipeService()
    private init() {}

    private static var recipeUrlParameters: Parameters = [
            "_app_key": ServicesKey.yummlyApiKey,
            "_app_id": ServicesKey.yummlyApiId
            ]

    // MARK: - FUNCTIONS

    func getRecipe(recipeId: String, callBack: @escaping (Bool, Recipe?, String) -> Void) {
        let getRecipeUrlString = RecipeService.getRecipeBaseUrlString + recipeId

//        AF.request(getRecipeUrlString).responseDecodable {(response: DataResponse<Recipe>) in
//                guard let recipe = response.value else {
//                    callBack(false, nil, "error in JSONDecoder")
//                    return
//                }
//
        AF.request(getRecipeUrlString).responseData { response in
            guard let data = response.result.value else {
                callBack(false, nil, "error in JSONDecoder")
                return
            }
            var recipe = Recipe()
            let decoder = JSONDecoder()

            if let context = CodingUserInfoKey.context {
                decoder.userInfo[context] = AppDelegate.viewContext
            }
            do { recipe = try decoder.decode(Recipe.self, from: data)
            } catch {
                print("error parsing")
            }
            callBack(true, recipe, "")
        }
    }
}
// TODO: Tests à faire
