//
//  MockCoreDataStack.swift
//  Recipes
//
//  Created by Antoine Antoniol on 15/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

import Recipes
import Foundation
import CoreData

final class MockCoreDataStack: CoreDataStack {

    // MARK: - Initializer

    convenience init() {
        self.init(modelName: "Recipes")
    }

    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
