//
//  MockRecipeSession.swift
//  Recipes
//
//  Created by Antoine Antoniol on 15/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

import Foundation

@testable import Recipes
import Foundation
import Alamofire

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
}

final class MockRecipeSession: AlamoSession {

    // MARK: - Properties

    private let fakeResponse: FakeResponse
    
    // MARK: - Initializer

    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    // MARK: - Methods

    func request(with url: URL, callBack: @escaping (DataResponse<Any>) -> Void) {
        let httpResponse = fakeResponse.response
        let data = fakeResponse.data
        
        let result = Request.serializeResponseJSON(options: .allowFragments, response: httpResponse, data: data, error: nil)
        let urlRequest = URLRequest(url: URL(string: "https://www.apple.com")!)
        callBack(DataResponse(request: urlRequest, response: httpResponse, data: data, result: result))
    }
}
