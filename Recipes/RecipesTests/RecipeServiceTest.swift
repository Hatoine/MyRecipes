//
//  RecipeServiceTest.swift
//  Recipes
//
//  Created by Antoine Antoniol on 15/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

import Foundation

@testable import Recipes
import XCTest

final class RequestServiceTests: XCTestCase {
    
    var ingredients: [String]?
    
    override func setUp() {
        super.setUp()
        ingredients = ["ham", "tomatoe"]
    }
    
    func testGetData_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        //Given
        let session = MockRecipeSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RecipeService(session: session)
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getData(ingredients: ingredients ?? [String]()) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with no data failed.")
                return
            }
            //Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetData_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        //Given
        let session = MockRecipeSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getData(ingredients: ingredients ?? [String]()) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with incorrect response failed.")
                return
            }
            //Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetData_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        //Give,n
        let session = MockRecipeSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RecipeService(session: session)
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getData(ingredients: ingredients ?? [String]()) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            //Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        //Given
        let session = MockRecipeSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getData(ingredients: ingredients ?? [String]()) { result in
            guard case .success(let data) = result else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            //Then
            XCTAssertTrue(data.hits[0].recipe.label == "Ham & Tomato Stromboli")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
