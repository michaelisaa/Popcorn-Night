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
        let movie = Movie(posterPath: nil, overview: "overview", releaseDate: " ", id: 1, title: "title", popularity: 1, voteAverage: 1)
        movieCell.configure(movie: movie)
        XCTAssertEqual(movie.title, movieCell.titleLabel.text)
        XCTAssertEqual(movie.overview, movieCell.overviewLabel.text)
    }
    
    func test_urlForMoviePoster_returnsNil_forNoPosterPath() {
        let movie = Movie(posterPath: nil, overview: "overview", releaseDate: " ", id: 1, title: "title", popularity: 1, voteAverage: 1)
        XCTAssertNil(movieCell.urlForMoviePoster(movie: movie))
    }
    
    func test_urlForMoviePoster_returnsCorrectURLString() {
        let movie = Movie(posterPath: "path/to/poster", overview: "overview", releaseDate: " ", id: 1, title: "title", popularity: 1, voteAverage: 1)
        let expectedURLString = "https://image.tmdb.org/t/p/w185" + movie.posterPath!
        let url = movieCell.urlForMoviePoster(movie: movie)
        XCTAssertEqual(expectedURLString, url?.absoluteString)
    }
}
