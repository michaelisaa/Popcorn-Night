//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import XCTest
@testable import Popcorn_Night

class MovieListCellTest: XCTestCase {
    let movieCell = MovieListCell()
    
    func test_configure_setsLabelsCorrectly() {
        let movie = TestHelper.generateMovie()!
        movieCell.configure(movie: movie)
        XCTAssertEqual(movie.title, movieCell.titleLabel.text)
        XCTAssertEqual(movie.overview, movieCell.overviewLabel.text)
    }
    
    func test_urlForMoviePoster_returnsCorrectURLString() {
        let movie = TestHelper.generateMovie()!
        let expectedURLString = "https://image.tmdb.org/t/p/w185" + movie.posterPath!
        let url = movieCell.urlForMoviePoster(movie: movie)
        XCTAssertEqual(expectedURLString, url?.absoluteString)
    }
}
