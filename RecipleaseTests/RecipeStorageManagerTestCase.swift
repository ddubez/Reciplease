//
//  RecipeStorageManagerTestCase.swift
//  RecipleaseTests
//
//  Created by David Dubez on 20/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import CoreData
@ testable import Reciplease

class RecipeStorageManagerTestCase: XCTestCase {

    var recipeTestStorageManager: RecipeStorageManager?

    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    //lazy var mockPersistantContainer: NSPersistentContainer = {
   lazy var mockPersistantContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Reciplease", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            // Check if creating container wrong
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()

    override func setUp() {
        super.setUp()
        recipeTestStorageManager = RecipeStorageManager(container: mockPersistantContainer)

    }

    override func tearDown() {
        super.tearDown()
        cleanData(for: "Recipe")
        cleanData(for: "IngredientLine")
    }

    func testFetchAllShouldReturnNillIfStoreEmpty() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }

        // When
        let fetch = recipeFuncTestStorageManager.fetchAllStored()

        // Then
        XCTAssertEqual(fetch.count, 0)
    }

    func testSaveRecipeShouldReturnOneRecipe() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let recipe = Recipe(context: mockPersistantContainer.viewContext)
        recipe.name = "new Recipe"

        // When
        try? recipeFuncTestStorageManager.saveRecipe(recipe)

        // Then
        let fetch = recipeFuncTestStorageManager.fetchAllStored()
        XCTAssertEqual(fetch.count, 1)
    }

    func testSaveRecipeTwiceShouldThrowError() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }

        let recipeOne = Recipe(context: mockPersistantContainer.viewContext)
        recipeOne.name = "new Recipe"
        recipeOne.recipeId = "recipeOne"
        try? recipeFuncTestStorageManager.saveRecipe(recipeOne)
        // When
        do {
            try recipeFuncTestStorageManager.saveRecipe(recipeOne)
        } catch let error {
            // Then
            XCTAssertEqual(error.message, "Failed to save recipe !")
        }
    }

    func testSaveRecipeWithIngredientLineShouldReturnGoodIngredient() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        var fetchedingredientOne: String?

        guard let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe",
                                                        into: mockPersistantContainer.viewContext) as? Recipe else {
                                                        return
        }
        recipe.setValue("new Recipe", forKey: "name")
        recipe.setValue("recipe", forKey: "recipeId")

        guard let ingredientLineOne = NSEntityDescription.insertNewObject(forEntityName: "IngredientLine",
                                    into: mockPersistantContainer.viewContext) as? IngredientLine else {
                                                               return
        }
        ingredientLineOne.setValue("oinions", forKey: "line")
        ingredientLineOne.setValue(recipe, forKey: "recipe")

        try? recipeFuncTestStorageManager.saveRecipe(recipe)

        // When
        let fetchedRecipe = recipeFuncTestStorageManager.fetchStored(recipeId: "recipe")

        // Then
        guard let fetchedingredientLine = fetchedRecipe?.ingredientLines else {
            return
        }
        if let fetchedingredientLineOne = fetchedingredientLine[0] as? IngredientLine {
            fetchedingredientOne = fetchedingredientLineOne.line
        }

        XCTAssertEqual(fetchedingredientOne, "oinions")
        XCTAssertEqual(fetchedRecipe?.name, "new Recipe")
    }

    func testFetchRecipewithCorrectIdShouldReturnRecipe() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let recipe = Recipe(context: mockPersistantContainer.viewContext)
        recipe.name = "new Recipe"
        recipe.recipeId = "new Recipe ID"
        try? recipeFuncTestStorageManager.saveRecipe(recipe)

        // When
        let fetchedRecipe = recipeFuncTestStorageManager.fetchStored(recipeId: "new Recipe ID")

        // Then
        XCTAssertNotNil(fetchedRecipe)
        XCTAssertEqual(fetchedRecipe?.recipeId, "new Recipe ID")
    }

    func testFetchRecipewithWrongIdShouldReturnNil() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let recipe = Recipe(context: mockPersistantContainer.viewContext)
        recipe.name = "new Recipe"
        recipe.recipeId = "new Recipe ID"
        try? recipeFuncTestStorageManager.saveRecipe(recipe)

        // When
        let fetchedRecipe = recipeFuncTestStorageManager.fetchStored(recipeId: "wrong ID")

        // Then
        XCTAssertNil(fetchedRecipe)
    }

    func testDeleteRecipeShouldReturnStoreEmpty() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let firstEmptyFetch = recipeFuncTestStorageManager.fetchAllStored()

        let recipeOne = Recipe(context: mockPersistantContainer.viewContext)
        recipeOne.name = "new Recipe"
        recipeOne.recipeId = "recipeOne"
        try? recipeFuncTestStorageManager.saveRecipe(recipeOne)

        let secondFetch = recipeFuncTestStorageManager.fetchAllStored()

        try? recipeFuncTestStorageManager.deleteRecipe(recipeId: "recipeOne")

        let finalFetch = recipeFuncTestStorageManager.fetchAllStored()

        // Then
        XCTAssertEqual(firstEmptyFetch.count, 0)
        XCTAssertEqual(secondFetch.count, 1)
        XCTAssertEqual(finalFetch.count, 0)
    }

    func testDeleteWrongRecipeShouldReturnError() {
        // Given
        guard let recipeFuncTestStorageManager = self.recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }

        let recipeOne = Recipe(context: mockPersistantContainer.viewContext)
        recipeOne.name = "new Recipe"
        recipeOne.recipeId = "recipeOne"
        try? recipeFuncTestStorageManager.saveRecipe(recipeOne)

        do {
             try recipeFuncTestStorageManager.deleteRecipe(recipeId: "wrong Recipe")
        } catch let error {
            // Then
            XCTAssertEqual(error.message, "Failed to find recipe to delete !")
        }

        let finalFetch = recipeFuncTestStorageManager.fetchAllStored()

        // Then
        XCTAssertEqual(finalFetch.count, 1)
    }

    private func cleanData(for entityName: String) {
        //remove all data created in test
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName:
            entityName)
        if let objs = try? mockPersistantContainer.viewContext.fetch(fetchRequest) {
            for case let obj as NSManagedObject in objs {
                mockPersistantContainer.viewContext.delete(obj)
            }
            try? mockPersistantContainer.viewContext.save()
        }
    }
}
