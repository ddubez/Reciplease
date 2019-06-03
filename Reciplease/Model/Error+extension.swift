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
        if let errorType = self as? NRError {
            switch errorType {
            case .noData:
                return NSLocalizedString("There is no data in the API response !", comment: "")
            }
        }
        if let errorType = self as? RecipeListService.RLSError {
            switch errorType {
            case .noRecipeList:
                return NSLocalizedString("There is no list of recipe in the API response !", comment: "")
            case .noMatch:
                return NSLocalizedString("There is no match in the list of recipe of the API response !", comment: "")
            case .noMatchCount:
                return NSLocalizedString("There is no match count in the list of recipe of the API response !",
                                         comment: "")
            }
        }
        if let errorType = self as? RecipeService.RSError {
            switch errorType {
            case .noRecipe:
                return NSLocalizedString("There is no recipe in the API response !", comment: "")
            }
        }
        if let errorType = self as? RecipeImageService.RISError {
            switch errorType {
            case .noImage:
                return NSLocalizedString("There is no image in the API response !", comment: "")
            }
        }
        if let errorType = self as? RecipeStorageManager.RSMError {
            switch errorType {
            case .cantInsertObject:
                return NSLocalizedString("Failed to insert new object in storage !", comment: "")
            case .cantSaveContext:
                return NSLocalizedString("Failed to save context !", comment: "")
            case .cantSaveRecipe:
                return NSLocalizedString("Failed to save recipe !", comment: "")
            case .cantDeleteRecipe:
                return NSLocalizedString("Failed to delete recipe !", comment: "")
            case .cantFindRecipeToDelete:
                return NSLocalizedString("Failed to find recipe to delete !", comment: "")
            }
        } else {
            return "\(NSLocalizedString("Error !", comment: ""))" + "\n" + String(describing: self)
        }
    }
}
