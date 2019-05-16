//
//  Error+extension.swift
//  Reciplease
//
//  Created by David Dubez on 14/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

/**
 extension to add a mesage to display depending of the error
 */
extension Error {
    var message: String {
        if let errorType = self as? RecipeListService.RLSError {
            switch errorType {
            case .noRecipeList:
                return "There is no list of recipe in the API response !"
            case .noMatch:
                return "There is no match in the list of recipe of the API response !"
            case .noMatchCount:
                return "There is no match count in the list of recipe of the API response !"
            }
        }
        if let errorType = self as? NRError {
            switch errorType {
            case .noData:
                return "There is no data in the API response !"
            }
        } else {
            return "Error !"
        }
    }
}
