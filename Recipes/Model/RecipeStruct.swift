//
//  recipeStruct.swift
//  Recipes
//
//  Created by Antoine Antoniol on 05/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import Foundation

// MARK: - Empty
struct RecipeData: Decodable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Decodable {
    let label: String
    let image: String
    let url: String
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let totalTime: Int
}

// MARK: - Ingredient
 struct Ingredient: Decodable {
    let text: String
}

struct RecipeRepresentable {
    let label: String
    var image: Data?
    let ingredients: [String]
    let ingredientLines: [String]
    let yield: String
    let totalTime: String
    let url: String
}
