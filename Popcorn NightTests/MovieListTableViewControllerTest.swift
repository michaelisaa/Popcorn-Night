//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Foundation
import XCTest
@testable import Popcorn_Night

class MovieListTableViewControllerTest: XCTestCase {
    let movieListVC = MovieListTableViewController()
    
    // MARK: - numberOfSections
    
    func test_numberOfSections_returnsOne_whenDonePaging() {
        movieListVC.canPage = false
        XCTAssertEqual(movieListVC.numberOfSections(in: movieListVC.tableView), 1)
    }
    
    func test_numberOfSections_returnsTwo_whenDonePaging() {
        movieListVC.canPage = true
        XCTAssertEqual(movieListVC.numberOfSections(in: movieListVC.tableView), 2)
    }
    
    // MARK: - numberOfRowsInSection
    
    func test_numberOfRowsInSection_returnsMovieCount_forFirstSection() {
        let movieA = Movie(posterPath: nil, overview: "a", releaseDate: "a", id: 0, title: "a", popularity: 0, voteAverage: 0)
        let movieB = Movie(posterPath: nil, overview: "b", releaseDate: "b", id: 0, title: "b", popularity: 0, voteAverage: 0)
        movieListVC.movies = [movieA, movieB]
        XCTAssertEqual(movieListVC.tableView(movieListVC.tableView, numberOfRowsInSection: 0), movieListVC.movies.count)
    }
    
    func test_numberOfRowsInSection_returnsOne_forLoadingSection() {
        XCTAssertEqual(movieListVC.tableView(movieListVC.tableView, numberOfRowsInSection: 1), 1)
    }
}
