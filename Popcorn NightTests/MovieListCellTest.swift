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
        let movie = TestHelper.generateMovie(title: "title", overview: "overview")
        movieCell.configure(movie: movie)
        XCTAssertEqual(movie.title, movieCell.titleLabel.text)
        XCTAssertEqual(movie.overview, movieCell.overviewLabel.text)
    }
    
    func test_urlForMoviePoster_returnsNil_forNoPosterPath() {
        let movie = Movie(posterPath: nil, backdropPath: nil, overview: "overview", releaseDate: "2018-01-03", movieId: 0, title: "title", popularity: 0, voteAverage: 8.9, originalLanguage: "En", voteCount: 1, budget: 1, homepage: "www.google.com", revenue: 1000, runtime: 180, tagline: "f", genres: [Genre(genreId: 1, name: "Action")], genreIds: nil)
        XCTAssertNil(movieCell.urlForMoviePoster(movie: movie))
    }
    
    func test_urlForMoviePoster_returnsCorrectURLString() {
        let movie = TestHelper.generateMovie(title: "title", overview: "overview")
        let expectedURLString = "https://image.tmdb.org/t/p/w185" + movie.posterPath!
        let url = movieCell.urlForMoviePoster(movie: movie)
        XCTAssertEqual(expectedURLString, url?.absoluteString)
    }
}
