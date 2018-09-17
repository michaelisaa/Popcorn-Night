 //
//  ApiClient.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 17/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Alamofire



class APICLient {
    
    typealias MoviesAPISuccess = (_ success:MoviesAPIResponse) -> Void
    typealias MoviesAPIFailure = (_ error:Error) -> Void
    
    static let baseURLString = "https://api.themoviedb.org/3/"
    static let apiKey = "796fee77f2c23a16feb57f8b626c2dbf"
    
    class public func listRecentMovies(page: Int, success: @escaping MoviesAPISuccess, failure: @escaping MoviesAPIFailure) {
        let parameters: Parameters = [
            "api_key": apiKey,
            "page": page
        ]
        getRequest(requestedURL: generateRequestURL(requestURL: "movie/popular"), parameters: parameters, success: success, failure: failure)
    }
    
    class public func searchMovies(query: String, page: Int, success: @escaping MoviesAPISuccess, failure: @escaping MoviesAPIFailure) {
        let parameters: Parameters = [
            "api_key": apiKey,
            "query": query,
            "page": page
            ]
        getRequest(requestedURL: generateRequestURL(requestURL: "search/movie"), parameters: parameters, success: success, failure: failure)
    }
    
    class func getRequest(requestedURL: String, parameters: Parameters, success: @escaping MoviesAPISuccess, failure: @escaping MoviesAPIFailure) {
        Alamofire.request(requestedURL, parameters: parameters).validate().responseData { response in
            switch response.result {
            case .success:
                do {
                    let recentMoviesResponse = try JSONDecoder().decode(MoviesAPIResponse.self, from: response.data!)
                    success(recentMoviesResponse)
                } catch let jsonError {
                    failure(jsonError)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    class func generateRequestURL(requestURL: String) -> String {
        return baseURLString + requestURL
    }
}
