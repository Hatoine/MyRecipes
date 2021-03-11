//
//  CoreDataManager.swift
//  Recipes
//
//  Created by Antoine Antoniol on 07/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    var recipeMOarray: [RecipeMO] {
        get {
            let request: NSFetchRequest<RecipeMO> = RecipeMO.fetchRequest()
            guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
            return recipes
        }
        set {
        }
    }
    
    // MARK: - Initializer
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    // MARK: - Methods
    
    func createRecipe(label: String, ingredientLines: String, totalTime: String, image: Data, url: String,ingredients: [String],yield: String) {
        let recipe = RecipeMO(context: managedObjectContext)
        recipe.label = label
        recipe.ingredientLines = ingredientLines
        recipe.ingredients = ingredients
        recipe.yield = yield
        recipe.totalTime = totalTime
        recipe.image = image
        recipe.url = url
        coreDataStack.saveContext()
    }
    
    func deleteAllFavorites() {
        recipeMOarray.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
    
    func deleteRecipe(label: String, url: String)  {
        let request: NSFetchRequest<RecipeMO> = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", label)
        request.predicate = NSPredicate(format: "url == %@", url)
        
        
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        coreDataStack.saveContext()
    }
    
    func checkIfRecipeIsFavorite(label: String, url: String) -> Bool {
        let request: NSFetchRequest<RecipeMO> = RecipeMO.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", label)
        request.predicate = NSPredicate(format: "url == %@", url)
        guard let counter = try? managedObjectContext.count(for: request) else { return false }
        return counter == 0 ? false : true
    }
}


