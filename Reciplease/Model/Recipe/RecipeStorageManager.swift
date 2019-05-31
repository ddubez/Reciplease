//
//  RecipeStorageManager.swift
//  Reciplease
//
//  Created by David Dubez on 20/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class RecipeStorageManager {
    let persistentContainer: NSPersistentContainer!

    //Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate unavailable")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    // MARK: - CRUD

    func fetchAllStored() -> [Recipe] {
        //Return all the recipes stored
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        guard let recipes = try? backgroundContext.fetch(request) else {
            return []
        }
        return recipes
    }

    func fetchStored(recipeId: String) -> Recipe? {
        //Return the recipe with the recipeId
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "recipeId == %@", recipeId)

        return try? backgroundContext.fetch(request).first
    }

    func saveRecipe(_ recipeToSave: Recipe) throws {
        //Insert the the recipe to Save in the backgroundContext
        do {
            try insertRecipe(recipeToInsert: recipeToSave)
        } catch let error {
            throw error
        }

        //Save the backgroundContext
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                throw RSMError.cantSaveContext
            }
        } else {
            throw RSMError.cantSaveRecipe
        }
    }

    func removeRecipe(objectID: NSManagedObjectID) throws {
        //Remove the object from the backgroundContext
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)

        //Save the backgroundContext
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                throw RSMError.cantSaveContext
            }
        } else {
            throw RSMError.cantDeleteRecipe
        }
    }

    private func insertRecipe( recipeToInsert: Recipe) throws {
        //Create new newObject to be inserted
        guard let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe",
                                                               into: backgroundContext) as? Recipe else {
                                                                throw RSMError.cantInsertObject
        }
        guard let source = NSEntityDescription.insertNewObject(forEntityName: "Source",
                                                               into: backgroundContext) as? Source else {
                                                                backgroundContext.delete(recipe)
                                                                throw RSMError.cantInsertObject
        }
        guard let image = NSEntityDescription.insertNewObject(forEntityName: "Image",
                                                              into: backgroundContext) as? Image else {
                                                                backgroundContext.delete(source)
                                                                backgroundContext.delete(recipe)
                                                                throw RSMError.cantInsertObject
        }
        guard let attribution = NSEntityDescription.insertNewObject(forEntityName: "Attribution",
                                                                    into: backgroundContext) as? Attribution else {
                                                                backgroundContext.delete(image)
                                                                backgroundContext.delete(source)
                                                                backgroundContext.delete(recipe)
                                                                throw RSMError.cantInsertObject
        }

        //set recipe to insert attributes
        recipe.imageForList = recipeToInsert.imageForList
        recipe.name = recipeToInsert.name
        recipe.rating = recipeToInsert.rating
        recipe.recipeId = recipeToInsert.recipeId
        recipe.totalTimeInSeconds = recipeToInsert.totalTimeInSeconds

        setSourceAttributes(for: source, from: recipeToInsert)
        recipe.source = source

        setAttributionAttributes(for: attribution, from: recipeToInsert)
        recipe.attribution = attribution

        setImageAttributes(for: image, from: recipeToInsert)
        recipe.images = image

        //set list of ingredientLine for recipe to insert
        var arrayOfIngredientLine = [IngredientLine]()
        if let recipeToInsertIngredientLines = recipeToInsert.ingredientLines {
            for ingedientsLineToInsert in recipeToInsertIngredientLines {
                if let ingredientLine = ingedientsLineToInsert as? IngredientLine {
                    let newIngredientLine = IngredientLine(context: backgroundContext)
                    newIngredientLine.line = ingredientLine.line
                    arrayOfIngredientLine.append(newIngredientLine)
                }
            }
        }
        recipe.ingredientLines = NSOrderedSet(array: arrayOfIngredientLine)
    }

    private func setSourceAttributes(for source: Source, from recipeToInsert: Recipe) {
        //set source attributes for recipe to insert
        source.sourceDisplayName = recipeToInsert.source?.sourceDisplayName
        source.sourceRecipeUrl = recipeToInsert.source?.sourceRecipeUrl
        source.sourceSiteUrl = recipeToInsert.source?.sourceSiteUrl
    }

    private func setAttributionAttributes(for attribution: Attribution, from recipeToInsert: Recipe) {
        //set attribution attributes for recipe to insert
        attribution.attributionHtml = recipeToInsert.attribution?.attributionHtml
        attribution.attributionUrl = recipeToInsert.attribution?.attributionUrl
        attribution.attributionLogo = recipeToInsert.attribution?.attributionLogo
        attribution.attributionText = recipeToInsert.attribution?.attributionText
    }

    private func setImageAttributes(for image: Image, from recipeToInsert: Recipe) {
        //set image attributes for recipe to insert
        image.hostedLargeUrl = recipeToInsert.images?.hostedLargeUrl
        image.hostedMediumUrl = recipeToInsert.images?.hostedMediumUrl
        image.hostedSmallUrl = recipeToInsert.images?.hostedSmallUrl
    }
}

extension RecipeStorageManager {
    /**
     'RSMError' is the error type returned by RecipeStorageManager.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     
     -  cantInsertObject: return when creating new object in backgroundContext failed
     */
    enum RSMError: Error {
        case cantInsertObject
        case cantSaveContext
        case cantSaveRecipe
        case cantDeleteRecipe
    }
}
