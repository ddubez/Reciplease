//
//  RecipeImageService.swift
//  Reciplease
//
//  Created by David Dubez on 09/04/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Alamofire

class RecipeImageService {
    // network request for retrieve recipe image

    private var recipeImageRequest: NetworkRequest = AlamofireNetworkRequest()
    init() {}
    init(recipeImageRequest: NetworkRequest) {
        self.recipeImageRequest = recipeImageRequest
    }

    func getIconImage(imageUrl: String, completionHandler: @escaping ((Data?) -> Void)) {
        recipeImageRequest.getData(dataUrl: imageUrl) { (data, error) in
            if error != nil {
                completionHandler(nil)
            }
            guard let data = data else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
    }
}

extension RecipeImageService {
    /**
     'RISError' is the error type returned by RecipeImageService.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     
     - noImage: return when there is no image return in get request
     */
    enum RISError: Error {
        case noImage
    }
}
