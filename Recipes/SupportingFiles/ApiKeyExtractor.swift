//
//  ApiKeyExtractor.swift
//  Recipes
//
//  Created by Antoine Antoniol on 15/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//


import Foundation

final class ApiKeyExtractor {
    var apiKey: ApiKey {
        guard let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"), let data = FileManager.default.contents(atPath: path) else {
            fatalError("can't find ApiKeys.plist")
        }
        guard let dataExtracted = try? PropertyListDecoder().decode(ApiKey.self, from: data) else {
            fatalError("can't load data from ApiKeys.plist")
        }
        return dataExtracted
    }
}

struct ApiKey: Decodable {
    let edamam: String
    let edamamId : String
}


