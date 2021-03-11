//
//  CoreDataManagerTests.swift
//  Recipes
//
//  Created by Antoine Antoniol on 15/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

@testable import Recipes
import XCTest

final class CoreDataManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!
    
    //MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    // MARK: - Tests
    
    func testAddRecipeMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.createRecipe(label: "My Recipe", ingredientLines: "Tomatoes", totalTime: "", image: Data() , url: "http://www.seriouseats.com/recipes/2009/09/adult-brownie-chocolate-salt-coffee-andronicos-supermarket-san-francisco-recipe.html", ingredients: ["Ingredients"], yield: "")
        XCTAssertTrue(!coreDataManager.recipeMOarray.isEmpty)
        XCTAssertTrue(coreDataManager.recipeMOarray.count == 1)
        XCTAssertTrue(coreDataManager.recipeMOarray[0].label == "My Recipe")
        XCTAssertTrue(coreDataManager.recipeMOarray[0].ingredients == ["Ingredients"])
        XCTAssertTrue(coreDataManager.recipeMOarray[0].ingredientLines == "Tomatoes")
        XCTAssertTrue(coreDataManager.recipeMOarray[0].yield == "")
        XCTAssertTrue(coreDataManager.recipeMOarray[0].totalTime == "")
        XCTAssertTrue(coreDataManager.recipeMOarray[0].image == Data() )
        XCTAssertTrue(coreDataManager.recipeMOarray[0].url == "http://www.seriouseats.com/recipes/2009/09/adult-brownie-chocolate-salt-coffee-andronicos-supermarket-san-francisco-recipe.html")
        
        let recipeIsFavorite = coreDataManager.checkIfRecipeIsFavorite(label: "My Recipe", url: "http://www.seriouseats.com/recipes/2009/09/adult-brownie-chocolate-salt-coffee-andronicos-supermarket-san-francisco-recipe.html")
        XCTAssertTrue(coreDataManager.recipeMOarray.count > 0)
        XCTAssertTrue(recipeIsFavorite)
    }
    
    func testDeleteRecipeMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.createRecipe(label: "Recipe", ingredientLines: "Tomatoes", totalTime: "", image: Data() , url: "http://www.seriouseats.com/recipes/2009/09/adult-brownie-chocolate-salt-coffee-andronicos-supermarket-san-francisco-recipe.html", ingredients: ["Ingredients"], yield: "")
        
        
        coreDataManager.deleteRecipe(label: "Recipe", url: "http://www.seriouseats.com/recipes/2009/09/adult-brownie-chocolate-salt-coffee-andronicos-supermarket-san-francisco-recipe.html")
    }
    
    func testDeleteAllRecipesMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyAllDeleted() {
        coreDataManager.createRecipe(label: "My Recipe", ingredientLines: "Tomatoes", totalTime: "", image: Data(), url: "http://www.seriouseats.com/recipes/2009/09/adult-brownie-chocolate-salt-coffee-andronicos-supermarket-san-francisco-recipe.html", ingredients: ["Ingredients"], yield: "")
        coreDataManager.deleteAllFavorites()
        XCTAssertTrue(coreDataManager.recipeMOarray.isEmpty)
        
        let recipeIsFavorite = coreDataManager.checkIfRecipeIsFavorite(label: "My Recipe", url: "http://www.seriouseats.com/recipes/2009/09/adult-brownie-chocolate-salt-coffee-andronicos-supermarket-san-francisco-recipe.html")
        XCTAssertFalse(recipeIsFavorite)
    }
}

