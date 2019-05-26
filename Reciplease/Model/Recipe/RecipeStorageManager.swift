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
    @discardableResult func insertRecipe( recipeToInsert: Recipe) -> Recipe? {
        //Create new newObject to be inserted
        guard let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe",
                                                               into: backgroundContext) as? Recipe else {
                                                                return nil }
        guard let source = NSEntityDescription.insertNewObject(forEntityName: "Source",
                                                               into: backgroundContext) as? Source else {
                                                                backgroundContext.delete(recipe)
                                                                return nil }
        guard let image = NSEntityDescription.insertNewObject(forEntityName: "Image",
                                                              into: backgroundContext) as? Image else {
                                                                backgroundContext.delete(source)
                                                                backgroundContext.delete(recipe)
                                                                return nil }
        guard let attribution = NSEntityDescription.insertNewObject(forEntityName: "Attribution",
                                                                    into: backgroundContext) as? Attribution else {
                                                                
                                                                backgroundContext.delete(image)
                                                                backgroundContext.delete(source)
                                                                backgroundContext.delete(recipe)
                                                                return nil }

        //set recipe to insert attributes
        recipe.imageForList = recipeToInsert.imageForList
        recipe.name = recipeToInsert.name
        recipe.rating = recipeToInsert.rating
        recipe.recipeId = recipeToInsert.recipeId
        recipe.totalTimeInSeconds = recipeToInsert.totalTimeInSeconds

        //set source attributes for recipe to insert
        source.sourceDisplayName = recipeToInsert.source?.sourceDisplayName
        source.sourceRecipeUrl = recipeToInsert.source?.sourceRecipeUrl
        source.sourceSiteUrl = recipeToInsert.source?.sourceSiteUrl
        recipe.source = source

        //set attribution attributes for recipe to insert
        attribution.attributionHtml = recipeToInsert.attribution?.attributionHtml
        attribution.attributionUrl = recipeToInsert.attribution?.attributionUrl
        attribution.attributionLogo = recipeToInsert.attribution?.attributionLogo
        attribution.attributionText = recipeToInsert.attribution?.attributionText
        recipe.attribution = attribution

        //set image attributes for recipe to insert
        image.hostedLargeUrl = recipeToInsert.images?.hostedLargeUrl
        image.hostedMediumUrl = recipeToInsert.images?.hostedMediumUrl
        image.hostedSmallUrl = recipeToInsert.images?.hostedSmallUrl
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

        return recipe
    }

    func fetchAll() -> [Recipe] {
        //Return all the recipes stored in viewContext
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        guard let recipes = try? persistentContainer.viewContext.fetch(request) else {
            return []
        }
        return recipes
    }

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

        guard let recipes = try? backgroundContext.fetch(request) else {
            return nil
        }
        return recipes.first
    }

    func save() {
        //Save the backgroundContext
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }

    func remove( objectID: NSManagedObjectID ) {
        //Remove the object
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
}
