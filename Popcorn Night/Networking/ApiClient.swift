 //
//  ApiClient.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 17/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Alamofire

struct RecentMoviesResponse: Decodable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case page = "page"
        case results = "results"
    }
}

class APICLient {
    
    typealias RecentMoviesSuccess = (_ success:RecentMoviesResponse?) -> Void
    typealias ApiFailure = (_ error:Error) -> Void
    
    static let baseURLString = "https://api.themoviedb.org/3/"
    static let apiKey = "796fee77f2c23a16feb57f8b626c2dbf"
    
    class public func getRecentMovies(success: @escaping RecentMoviesSuccess, failure: @escaping ApiFailure) {
        let parameters: Parameters = [
            "api_key": apiKey,
        ]
        Alamofire.request(generateRequestURL(requestURL: "movie/popular"), parameters: parameters).responseData { response in
            if let error = response.error {
                failure(error)
                return
            }
            do {
                let recentMoviesResponse = try JSONDecoder().decode(RecentMoviesResponse.self, from: response.data!)
                success(recentMoviesResponse)
                return
            } catch let jsonError {
                success(nil)
                return
            }
            return
        }
    }
    
    class func generateRequestURL(requestURL: String) -> String {
        return baseURLString + requestURL
    }
}
