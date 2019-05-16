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

    static var shared = RecipeListService()
    private init() {}

    private var recipeListRequest: NetworkRequest = AlamofireNetworkRequest()
    init(recipeListRequest: NetworkRequest) {
        self.recipeListRequest = recipeListRequest
    }

    private static var recipeListUrlParameters: Parameters = [
        "_app_key": ServicesKey.yummlyApiKey,
        "_app_id": ServicesKey.yummlyApiId,
        "maxResult": 20
    ]

    // MARK: - FUNCTIONS

    func getRecipeList(searchPhrase: String, start: Int,
                       callBack: @escaping (Bool, [RecipeList.Matche]?, Int?, Error?) -> Void) {

        RecipeListService.recipeListUrlParameters.updateValue(searchPhrase, forKey: "q")
        RecipeListService.recipeListUrlParameters.updateValue(start, forKey: "start")

        recipeListRequest.get(url: RecipeListService.searchRecipeListBaseUrlString,
                                 parameters: RecipeListService.recipeListUrlParameters
                                ) { (recipeList: RecipeList?, error) in
            if let error = error {
                callBack(false, nil, nil, error)
                return
            }
            guard let recipeListGetted = recipeList else {
                callBack(false, nil, nil, RLSError.noRecipeList)
                return
            }

            guard let recipeListMatches = recipeListGetted.matches else {
                callBack(false, nil, nil, RLSError.noMatch)
                return
            }

            guard let numberOfResult = recipeListGetted.totalMatchCount else {
                callBack(false, nil, nil, RLSError.noMatchCount)
                return
            }

            callBack(true, recipeListMatches, numberOfResult, nil)

        }
    }
}

extension RecipeListService {
    /**
     'RLSError' is the error type returned by RecipeListService.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     
     - noRecipeList: return when there is no recipe list return in get request
     - noMatche: return when there is no match in recipe list
     */
    enum RLSError: Error {
        case noRecipeList
        case noMatch
        case noMatchCount
    }
}
