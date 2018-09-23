//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 23/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import XCTest
@testable import Popcorn_Night

class MovieTest: XCTestCase {
    var movie = TestHelper.generateMovie()!
    
    func test_releaseYear() {
        XCTAssertTrue(movie.releaseYear() == "2016")
    }
    
    func test_genresString_withNoGenres() {
        XCTAssertNil(movie.genres)
        XCTAssertNil(movie.genresString())
    }
    
    func test_genresString_withGenres() {
        movie.genres = TestHelper.generateGenreArray(numberOfItems: 2)
        let expectedGenreString = "Action | Adventure"
        XCTAssertTrue(movie.genresString() == expectedGenreString)
    }
}
