//
//  RecipeListTestCase.swift
//  RecipleaseTests
//
//  Created by David Dubez on 02/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import CoreData

@testable import Reciplease

class RecipeListTestCase: XCTestCase {

    var recipeTestStorageManager: RecipeStorageManager?

    lazy var managedObjectModel: NSManagedObjectModel = {
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
        cleanData(for: "Recipe")
        cleanData(for: "IngredientLine")
    }

    func testInitRecipeListMatchewithRecipeShouldReturnGoodRecipeListMatche() {
        // Given
        guard let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe",
                                        into: mockPersistantContainer.viewContext) as? Recipe else {
                                        return
        }
        recipe.setValue("new Recipe", forKey: "name")
        recipe.setValue("id recipe", forKey: "recipeId")

        guard let ingredientLineOne = NSEntityDescription.insertNewObject(forEntityName: "IngredientLine",
                                        into: mockPersistantContainer.viewContext) as? IngredientLine else {
                                        return
        }
        ingredientLineOne.setValue("oinions", forKey: "line")
        ingredientLineOne.setValue(recipe, forKey: "recipe")

        // When
        let recipeListMatche = RecipeList.Matche(with: recipe)

        // Then
        XCTAssertEqual(recipeListMatche?.referenceId, "id recipe")
        XCTAssertEqual(recipeListMatche?.recipeName, "new Recipe")
        XCTAssertEqual(recipeListMatche?.ingredients, ["oinions"])

    }

    func testInitRecipeListMatchewithRecipeWithNoIdShouldReturnNil() {
        // Given
        guard let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe",
                                        into: mockPersistantContainer.viewContext) as? Recipe else {
                                        return
        }

        // When
        let recipeListMatche = RecipeList.Matche(with: recipe)

        // Then
        XCTAssertNil(recipeListMatche)

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
