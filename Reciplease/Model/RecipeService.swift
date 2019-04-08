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
    private static let recipeBaseUrlString = "https://api.yummly.com/v1/api/recipes"

    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
    static var shared = RecipeService()
    private init() {}

//    private static let recipeUrlParameters: Parameters = [
//        "_app_key": ServicesKey.yummlyApiKey,
//        "_app_id": ServicesKey.yummlyApiId,
//        "q": "onion+egg+butter+milk"
//        ]

    // TODO: gestion parameters??

    // MARK: - FUNCTIONS

    func getListRecipe(searchPhrase: String,
                       callBack: @escaping (Bool, RecipeList?, String) -> Void) {
        // TODO: Gestion des ingredients ??

        let recipeUrlParameters: Parameters = [
            "_app_key": ServicesKey.yummlyApiKey,
            "_app_id": ServicesKey.yummlyApiId,
            "q": searchPhrase
        ]

        AF.request(RecipeService.recipeBaseUrlString,
                   parameters: recipeUrlParameters ).responseJSON { (response) in
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

                    callBack(true, recipeList, "")

        }

    }
}
