//
//  recipeService.swift
//  Recipes
//
//  Created by Antoine Antoniol on 05/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import Foundation

final class RecipeService {
    
    private let session : AlamoSession
    private let apiKeyExtractor = ApiKeyExtractor()
    
    // MARK: - Initializer
    
    init(session: AlamoSession = RecipeSession()) {
        self.session = session
    }
    
    // MARK: - Enumeration
    
    enum RecipesError: Error {
        case noData, incorrectResponse, undecodable
    }
    
    // MARK: - Methods
    
    private func recipesUrl(list:[String]) -> String {
        let app_id = apiKeyExtractor.apiKey.edamamId
        let app_key = apiKeyExtractor.apiKey.edamam
        let url = "https://api.edamam.com/search?q=\(list.joined(separator:","))&app_id=\(app_id)&app_key=\(app_key)"
        return url
    }
    
    /// Network call to get recipes data
    
    func getData(ingredients:[String],callback: @escaping (Result<RecipeData, Error>) -> Void) {
        guard let url = URL(string: recipesUrl(list:ingredients)) else { return }
        session.request(with: url) { responseData in
            guard let data = responseData.data else {
                callback(.failure(RecipesError.noData))
                return
            }
            guard responseData.response?.statusCode == 200 else {
                callback(.failure(RecipesError.incorrectResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(RecipeData.self, from: data) else {
                callback(.failure(RecipesError.undecodable))
                return
            }
            callback(.success(dataDecoded))
        }
    }
}


