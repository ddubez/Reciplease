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

    func getIconImage(imageUrl: String, completionHandler: @escaping ((Data?) -> Void)) {
        AF.request(imageUrl).responseData { response in

            guard let data = response.result.value else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
    }

}
