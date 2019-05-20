//
//  RecipeStorageManager.swift
//  Reciplease
//
//  Created by David Dubez on 20/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreData

class RecipeStorageManager {
    let persistentContainer: NSPersistentContainer!

    //Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    convenience init() {
        //Use the default container for production environment
        self.init(container: AppDelegate.persistentContainer)
    }

    func fetchAll() -> [Recipe] {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        guard let recipes = try? persistentContainer.viewContext.fetch(request) else {
            return []
        }
        return recipes
    }
}

//  TODO: -automaticallyMerge ????
