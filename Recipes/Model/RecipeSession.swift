//
//  recipeService.swift
//  Recipes
//
//  Created by Antoine Antoniol on 05/12/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Alamofire session

protocol AlamoSession {
    func request(with url: URL, callBack: @escaping (DataResponse<Any>) -> Void)
}

final class RecipeSession: AlamoSession {
    func request(with url: URL, callBack: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url).responseJSON { responseData in
            callBack(responseData)
        }
    }
}


