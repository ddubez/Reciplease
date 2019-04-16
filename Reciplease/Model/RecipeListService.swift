//
//  RecipeListService.swift
//  Reciplease
//
//  Created by David Dubez on 13/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Alamofire

class RecipeListService {
    // network request for retrieve recipe data in Recipe Class

    // MARK: - PROPERTIES
    private static let searchRecipeListBaseUrlString = "https://api.yummly.com/v1/api/recipes"

    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
    static var shared = RecipeListService()
    private init() {}

    private static var recipeListUrlParameters: Parameters = [
        "_app_key": ServicesKey.yummlyApiKey,
        "_app_id": ServicesKey.yummlyApiId,
        "maxResult": 20
    ]

    // MARK: - FUNCTIONS

    func getRecipeList(searchPhrase: String, start: Int,
                       callBack: @escaping (Bool, [RecipeList.Matche]?, Int?, String) -> Void) {

        RecipeListService.recipeListUrlParameters.updateValue(searchPhrase, forKey: "q")
        RecipeListService.recipeListUrlParameters.updateValue(start, forKey: "start")

        AF.request(RecipeListService.searchRecipeListBaseUrlString,
                   parameters: RecipeListService.recipeListUrlParameters)
            .responseDecodable {(response: DataResponse<RecipeList>) in
                guard let recipeList = response.value else {
                    callBack(false, nil, nil, "error in JSONDecoder")
                    return
                }

                guard let recipeListMatches = recipeList.matches else {
                    callBack(false, nil, nil, "error no matche")
                    return
                }

                guard let numberOfResult = recipeList.totalMatchCount else {
                    return
                }

                callBack(true, recipeListMatches, numberOfResult, "")
        }
    }
}
// TODO:    - Tests à faire
//          - gerer les erreurs dans l'appel de la fonction
