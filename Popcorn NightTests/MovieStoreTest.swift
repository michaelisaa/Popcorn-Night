//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 21/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import XCTest
@testable import Popcorn_Night

class MovieStoreTest: XCTestCase {
    let movieStore = MovieStore.shared
    
    
    // Mark: - Movies
    
    func test_moviesFilePath() {
        let filePath = movieStore.movieStoreFilePath.split(separator: "/").last!
        XCTAssertTrue(filePath == "Movies")
    }
    
    func test_storingMovies() {
        let expectedMovies = TestHelper.generateMovieArray(numberOfItems: 3)!
        movieStore.store(movies: expectedMovies)
        let movies = movieStore.loadMoviesFromStore()!
        let result = movies.elementsEqual(expectedMovies) {
                $0.movieId == $1.movieId && $0.title == $1.title
        }
        XCTAssertTrue(result)
    }
    
    // Mark: - Genres
    
    func test_genresFilePath() {
        let filePath = movieStore.genreFilePath.split(separator: "/").last!
        XCTAssertTrue(filePath == "Genres")
    }
    
    func test_storingGenres() {
        let expectedGenres = TestHelper.generateGenreArray(numberOfItems: 3)!
        movieStore.store(genres: expectedGenres)
        let genres = movieStore.loadGenresFromStore()!
        let result = genres.elementsEqual(expectedGenres) {
            $0.genreId == $1.genreId && $0.name == $1.name
        }
        XCTAssertTrue(result)
    }
}
