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
    
    func test_listRecentMovies_callsCorrectEndpoint() {
        let page = 1
        
        let expectation = self.expectation(description: "check paramaters and path used for listing movies")
        stub(condition: { (urlRequest) -> Bool in
            guard let url = urlRequest.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems else { return false}
            let pageParameter = URLQueryItem(name: "page", value: String(page))
            let apiKeyParameter = URLQueryItem(name: "api_key", value: APIClient.apiKey)
            XCTAssertTrue(queryItems.contains(pageParameter))
            XCTAssertTrue(queryItems.contains(apiKeyParameter))
            XCTAssertEqual(url.path, "/3/movie/popular")
            return true
        }) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validJSONRepsonse(), statusCode: 200, headers: nil)
        }
        
        APIClient.listRecentMovies(page: page, success: { (movieAPIResponse) in
            expectation.fulfill()
        }) { (error) in }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_listRecentMovies_withInvalidJsonObject_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        
        APIClient.listRecentMovies(page: 1, success: { (movieAPIResponse) in
            
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
        
        APIClient.listRecentMovies(page: 1, success: { (movieAPIResponse) in
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
        
        APIClient.listRecentMovies(page: 1, success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    // MARK: - Genres List
    
    func test_getGenreList_callsCorrectEndpoint() {
        let expectation = self.expectation(description: "check paramaters and path used for listing genres")
        stub(condition: { (urlRequest) -> Bool in
            guard let url = urlRequest.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems else { return false}
            let apiKeyParameter = URLQueryItem(name: "api_key", value: APIClient.apiKey)
            XCTAssertTrue(queryItems.contains(apiKeyParameter))
            XCTAssertEqual(url.path, "/3/genre/movie/list")
            return true
        }) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validGenresRespons(), statusCode: 200, headers: nil)
        }
        
        APIClient.getGenreList( success: { (movieAPIResponse) in
            expectation.fulfill()
        }) { (error) in }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_getGenreList_withInvalidJsonObject_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        
        APIClient.getGenreList(success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_getGenreList_withSuccesfullResponse_callsSuccessBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validGenresRespons(), statusCode: 200, headers: nil)
        }
        
        APIClient.getGenreList( success: { (movieAPIResponse) in
            expectation.fulfill()
        }) { (error) in
            
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_getGenreList_withErrorStatusCode_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validJSONRepsonse(), statusCode: 404, headers: nil)
        }
        
        APIClient.getGenreList(success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    // MARK: - Search Movies
    
    func test_searchMovies_callsCorrectEndpoint() {
        let query = "search"
        let page = 1
        
        let expectation = self.expectation(description: "check paramaters and path used for search query")
        stub(condition: { (urlRequest) -> Bool in
            guard let url = urlRequest.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems else { return false}
            let pageParameter = URLQueryItem(name: "page", value: String(page))
            let queryParameter = URLQueryItem(name: "query", value: query)
            let apiKeyParameter = URLQueryItem(name: "api_key", value: APIClient.apiKey)
            XCTAssertTrue(queryItems.contains(pageParameter))
            XCTAssertTrue(queryItems.contains(queryParameter))
            XCTAssertTrue(queryItems.contains(apiKeyParameter))
            XCTAssertEqual(url.path, "/3/search/movie")
            return true
        }) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        
        APIClient.searchMovies(query: query, page: page, success: { (movieAPIResponse) in}) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_searchMovies_withInvalidJsonObject_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        
        APIClient.searchMovies(query: "search", page: 1, success: { (movieAPIResponse) in
            
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
        
        APIClient.searchMovies(query: "search", page: 1, success: { (movieAPIResponse) in
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
        
        APIClient.searchMovies(query: "search", page: 1, success: { (movieAPIResponse) in
            
        }) { (error) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    // MARK: - API Config
    
    func test_getConfig_callsCorrectEndpoint() {
        let expectation = self.expectation(description: "check paramaters and path used for getting api config")
        stub(condition: { (urlRequest) -> Bool in
            guard let url = urlRequest.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems else { return false}
            let apiKeyParameter = URLQueryItem(name: "api_key", value: APIClient.apiKey)
            XCTAssertTrue(queryItems.contains(apiKeyParameter))
            XCTAssertEqual(url.path, "/3/configuration")
            return true
        }) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        APIClient.getAPIConfig(success: { (config) in
            
        }) { (_) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_getConfig_withInvalidJsonObject_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            let invalidResponse = ["key1":"value1"]
            return OHHTTPStubsResponse(jsonObject: invalidResponse, statusCode: 200, headers: nil)
        }
        
        APIClient.getAPIConfig(success: { (config) in
            
        }) { (_) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_getConfig_withSuccesfullResponse_callsSuccessBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validConfigRespons(), statusCode: 200, headers: nil)
        }
        APIClient.getAPIConfig(success: { (config) in
            expectation.fulfill()
        }) { (_) in
            
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func test_getConfig_withErrorStatusCode_callsFailureBlock() {
        let expectation = self.expectation(description: "calls failure block when returned json is invalid")
        stub(condition: isHost("api.themoviedb.org")) { (urlRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(jsonObject: self.validConfigRespons(), statusCode: 404, headers: nil)
        }
        
        APIClient.getAPIConfig(success: { (config) in
        }) { (_) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    // MARK: - Test Helpers
    
    func validGenresRespons() -> Dictionary<String, Any> {
        return [
            "genres": [
                        [
                        "id": 28,
                        "name": "Action"
                        ]
                    ]
        ]
    }
    
    func validConfigRespons() -> Dictionary<String, Any> {
        return [
            "images": [
                        "secure_base_url": "https://image.tmdb.org/t/p/",
                      ],
            "change_keys": ["action"]
        ]
    }
    
    func validJSONRepsonse() -> Dictionary<String, Any> {
        let movieJSON:[String : Any] = [
            "overview": "overview",
            "release_date": "10-12-2018",
            "id": 1,
            "title": "title",
            "popularity": 0,
            "vote_average" : 0,
            "vote_count": 0,
            "poster_path": "www"
            ]
        
        return [
            "total_results": 5,
            "total_pages": 2,
            "page": 1,
            "results": [movieJSON]
        ]
    }
    
}
