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

    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

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
    }

    func testFetchAllShouldReturnNillIfStoreEmpty() {
        // Given
        guard let recipeTestStorageManager = recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }

        // When
        let fetch = recipeTestStorageManager.fetchAllStored()

        // Then
        XCTAssertEqual(fetch.count, 0)
    }

    func testInsertRecipeShouldReturnRecipe() {
        // Given
        guard let recipeTestStorageManager = recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let recipe = Recipe(context: mockPersistantContainer.viewContext)
        recipe.name = "new Recipe"

        // When
        recipeTestStorageManager.insertRecipe(recipeToInsert: recipe)

        // Then
        let fetch = recipeTestStorageManager.fetchAllStored()
        XCTAssertEqual(fetch.count, 1)
    }

    func testFetchRecipewithCorrectIdShouldReturnRecipe() {
        // Given
        guard let recipeTestStorageManager = recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let recipe = Recipe(context: mockPersistantContainer.viewContext)
        recipe.name = "new Recipe"
        recipe.recipeId = "new Recipe ID"
        recipeTestStorageManager.insertRecipe(recipeToInsert: recipe)

        // When
        let fetchedRecipe = recipeTestStorageManager.fetchStored(recipeId: "new Recipe ID")

        // Then
        XCTAssertNotNil(fetchedRecipe)
        XCTAssertEqual(fetchedRecipe?.recipeId, "new Recipe ID")
    }

    func testFetchRecipewithWrongIdShouldReturnNil() {
        // Given
        guard let recipeTestStorageManager = recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let recipe = Recipe(context: mockPersistantContainer.viewContext)
        recipe.name = "new Recipe"
        recipe.recipeId = "new Recipe ID"
        recipeTestStorageManager.insertRecipe(recipeToInsert: recipe)

        // When
        let fetchedRecipe = recipeTestStorageManager.fetchStored(recipeId: "wrong ID")

        // Then
        XCTAssertNil(fetchedRecipe)
    }

    func testsaveRecipeShouldReturnNil() {
        // Given
        guard let recipeTestStorageManager = recipeTestStorageManager else {
            XCTFail("recipeTestStorageManager is Nil !")
            return
        }
        let recipe = Recipe(context: mockPersistantContainer.viewContext)
        recipe.name = "new Recipe"
        recipe.recipeId = "new Recipe ID"
        recipeTestStorageManager.insertRecipe(recipeToInsert: recipe)

        // When
        let fetchedRecipe = recipeTestStorageManager.fetchStored(recipeId: "wrong ID")

        // Then
        XCTAssertNil(fetchedRecipe)
    }

}
//TODO: - finire les test
