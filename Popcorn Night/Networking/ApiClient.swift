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
    
    class public func getRecentMovies(page: Int, success: @escaping MoviesAPISuccess, failure: @escaping MoviesAPIFailure) {
        let parameters: Parameters = [
            "api_key": apiKey,
        ]
        Alamofire.request(generateRequestURL(requestURL: "movie/popular"), parameters: parameters).validate().responseData { response in
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
