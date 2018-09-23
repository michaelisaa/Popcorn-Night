//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 20/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

@testable import Popcorn_Night
import Foundation

class TestHelper  {
    
    // MARK: - Movies
    
    class func generateMovie() -> Movie? {
        if let movies = generateMovieArray(numberOfItems: 1) {
            return movies.first
        }
        return nil
    }
    
    class func generateMovieArray(numberOfItems: Int) -> [Movie]? {
        let data = loadDataFromFile(fileName: "Movies")
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: data)
            return Array(movies[0...(numberOfItems - 1)])
        } catch {
            return nil
        }
    }
    
    // MARK: - Genres
    
    class func generateGenre() -> Genre? {
        if let genres = generateGenreArray(numberOfItems: 1) {
            return genres.first
        }
        return nil
    }
    
    class func generateGenreArray(numberOfItems: Int) -> [Genre]? {
        let data = loadDataFromFile(fileName: "Genres")
        do {
            let genres = try JSONDecoder().decode([Genre].self, from: data)
            return Array(genres[0...(numberOfItems - 1)])
        } catch {
            return nil
        }
    }
    
    // MARK: - Config
    
    class func generateConfig() -> APIConfig? {
        let data = loadDataFromFile(fileName: "Config")
        do {
            let config = try JSONDecoder().decode(APIConfig.self, from: data)
            return config
        } catch {
            return nil
        }
    }
    
    // MARK: - Loading Files
    
    class func pathForFile(fileName: String, type: String) -> String? {
        return Bundle(for: self).path(forResource: fileName, ofType: type)
    }
    
    class func loadDataFromFile(fileName: String) -> Data {
        if let path = pathForFile(fileName: fileName, type: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return Data()
            }
        }
        return Data()
    }
}
