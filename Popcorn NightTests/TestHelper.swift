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
    
    class func generateMovie() -> Movie? {
        let data = loadDataFromFile(fileName: "Movies")
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: data)
            return movies.first
        } catch {
            return nil
        }
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
