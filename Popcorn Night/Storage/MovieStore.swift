//
//  File.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 21/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Foundation

class MovieStore {
    
    static let shared = MovieStore()
    let movieStoreFilePath: String
    let genreFilePath: String
    let configFilePath: String
    let numberOfMoviesToStore = 20
    
    private init() {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        movieStoreFilePath = url!.appendingPathComponent("Movies").path
        genreFilePath = (url!.appendingPathComponent("Genres").path)
        configFilePath = (url!.appendingPathComponent("Config").path)
    }
    
    // MARK - Movies
    
    func store(movies: [Movie]) {
        do {
            guard movies.count > 0 else {return}
            let maxIndex = min(movies.count, numberOfMoviesToStore) - 1
            // Only store 20 movies
            let moviesToStore = movies[0...maxIndex]
            let data = try PropertyListEncoder().encode(Array(moviesToStore))
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: movieStoreFilePath)
            print(success ? "Successful save" : "Save Failed")
        } catch {
            print("Save Failed  \(error)")
        }
    }
    
    func loadMoviesFromStore() -> [Movie]? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: movieStoreFilePath) as? Data else { return nil }
        do {
            let movies = try PropertyListDecoder().decode([Movie].self, from: data)
            return movies
        } catch {
            print("Retrieving movies Failed")
            return nil
        }
    }
    
    // MARK - Genres
    
    func store(genres: [Genre]) {
        do {
            let data = try PropertyListEncoder().encode(genres)
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: genreFilePath)
            print(success ? "Successful save" : "Save Failed")
        } catch {
            print("Save Failed  \(error)")
        }
    }
    
    func loadGenresFromStore() -> [Genre]? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: genreFilePath) as? Data else { return nil }
        do {
            let genres = try PropertyListDecoder().decode([Genre].self, from: data)
            return genres
        } catch {
            print("Retrieving genres Failed")
            return nil
        }
    }
    
    // MARK: - Config
    
    func store(config: APIConfig) {
        do {
            let data = try PropertyListEncoder().encode(config)
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: configFilePath)
            print(success ? "Successful save" : "Save Failed")
        } catch {
            print("Save Failed  \(error)")
        }
    }
    
    func loadConfigFromStore() -> APIConfig? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: configFilePath) as? Data else { return nil }
        do {
            let config = try PropertyListDecoder().decode(APIConfig.self, from: data)
            return config
        } catch {
            print("Retrieving genres Failed")
            return nil
        }
    }
}
