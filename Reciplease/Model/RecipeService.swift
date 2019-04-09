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
    private static let searchRecipeBaseUrlString = "https://api.yummly.com/v1/api/recipes"
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

    func getListRecipe(searchPhrase: String,
                       callBack: @escaping (Bool, [RecipeList.Matche]?, String) -> Void) {

        RecipeService.recipeUrlParameters.updateValue(searchPhrase, forKey: "q")

        AF.request(RecipeService.searchRecipeBaseUrlString,
                   parameters: RecipeService.recipeUrlParameters ).responseJSON { (response) in
                        guard let json = response.data else {
                        callBack(false, nil, "error in JSON")
                        return
                    }
                    guard let responseJSON = try? JSONDecoder().decode(RecipeList.self, from: json) else {
                        callBack(false, nil, "error in JSONDecoder")
                        return
                    }
                    // TODO: Meilleurs solution pour parser ?
                    let recipeList = responseJSON

                    let getIconImagesGroup = DispatchGroup()

                    guard var recipeListMatches = recipeList.matches else {
                        callBack(false, nil, "error no matche")
                        return
                    }

                    for index in 0...(recipeListMatches.count - 1) {
                        getIconImagesGroup.enter()

                        guard let smallImageUrls = recipeListMatches[index].smallImageUrls else {
                            recipeListMatches[index].listImage = UIImage(named: "noPhoto")
                            getIconImagesGroup.leave()
                            return
                        }
                        let recipeImageService = RecipeImageService()
                        recipeImageService.getIconImage(imageUrl: smallImageUrls[0], completionHandler: { (data) in
                            guard let data = data else {
                                recipeListMatches[index].listImage = UIImage(named: "noPhoto")
                                getIconImagesGroup.leave()
                                return
                            }
                            recipeListMatches[index].listImage = UIImage(data: data)
                            getIconImagesGroup.leave()
                        })
                    }

                    getIconImagesGroup.notify(queue: .main) {
                        callBack(true, recipeListMatches, "")
                    }
        }
    }

    func getRecipe(recipeId: String, callBack: @escaping (Bool, RecipeStruct?, String) -> Void) {
        let getRecipeUrlString = RecipeService.getRecipeBaseUrlString + recipeId

        AF.request(getRecipeUrlString).responseJSON { (response) in
                    guard let json = response.data else {
                        callBack(false, nil, "error in JSON")
                        return
                    }
                    guard let responseJSON = try? JSONDecoder().decode(RecipeStruct.self, from: json) else {
                        callBack(false, nil, "error in JSONDecoder")
                        return
                    }
                    // TODO: Meilleurs solution pour parser ?
                    let recipe = responseJSON

                    callBack(true, recipe, "")
        }
    }
}
