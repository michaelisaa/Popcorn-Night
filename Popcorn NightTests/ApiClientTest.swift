//
//  Popcorn_NightTests.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 17/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import Popcorn_Night

class ApiClientTest: XCTestCase {
    

    // MARK: - List Movies
    
    func test_listRecentMovies_withInvalidJsonObject_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        
        APICLient.listRecentMovies(page: 1, success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_listRecentMovies_withSuccesfullResponse_callsSuccessBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validJSONRepsonse(), statusCode: 200, headers: nil)
        }
        
        APICLient.listRecentMovies(page: 1, success: { (movieAPIResponse) in
            expectation.fulfill()
        }) { (error) in
            
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_listRecentMovies_withErrorStatusCode_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validJSONRepsonse(), statusCode: 404, headers: nil)
        }
        
        APICLient.listRecentMovies(page: 1, success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    // MARK: - Search Movies
    
    func test_searchMovies_withInvalidJsonObject_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        
        APICLient.searchMovies(query: "search", page: 1, success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_searchMovies_withSuccesfullResponse_callsSuccessBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validJSONRepsonse(), statusCode: 200, headers: nil)
        }
        
        APICLient.searchMovies(query: "search", page: 1, success: { (movieAPIResponse) in
            expectation.fulfill()
        }) { (error) in
            
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_searchMovies_withErrorStatusCode_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validJSONRepsonse(), statusCode: 404, headers: nil)
        }
        
        APICLient.searchMovies(query: "search", page: 1, success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    // MARK: - Test Helpers
    
    func validJSONRepsonse() -> Dictionary<String, Any> {
        let movieJSON:[String : Any] = [
            "overview": "overview",
            "release_date": "10-12-2018",
            "id": 1,
            "title": "title",
            "popularity": 0,
            "vote_average" : 0,
            ]
        
        return [
            "total_results": 5,
            "total_pages": 2,
            "page": 1,
            "results": [movieJSON]
        ]
    }
    
}
