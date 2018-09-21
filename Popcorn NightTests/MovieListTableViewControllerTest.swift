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
        movieListVC.movies = TestHelper.generateMovieArray(numberOfItems: 2)!
        XCTAssertEqual(movieListVC.tableView(movieListVC.tableView, numberOfRowsInSection: 0), movieListVC.movies.count)
    }
    
    func test_numberOfRowsInSection_returnsOne_forLoadingSection() {
        XCTAssertEqual(movieListVC.tableView(movieListVC.tableView, numberOfRowsInSection: 1), 1)
    }
    
    // MARK: - moviesToDisplay
    
    func test_moviesToDisplay_returnsMoviesListWhenNotSearching() {
        movieListVC.movies = TestHelper.generateMovieArray(numberOfItems: 2)!
        movieListVC.searchMovies = TestHelper.generateMovieArray(numberOfItems: 1)!
        movieListVC.currentSearchQuery = nil
        XCTAssertEqual(movieListVC.moviesToDisplay().count, 2)
    }
    
    func test_moviesToDisplay_returnsSearchResultsWhenSearching() {
        movieListVC.movies = TestHelper.generateMovieArray(numberOfItems: 2)!
        movieListVC.searchMovies = TestHelper.generateMovieArray(numberOfItems: 1)!
        movieListVC.currentSearchQuery = "searching"
        XCTAssertEqual(movieListVC.moviesToDisplay().count, 1)
    }
    
    // MARK: - hasNextPage
    
    func test_hasNextPage_returnsMoviesListCanPageWhenNotSearching() {
        movieListVC.currentSearchQuery = nil
        movieListVC.canPage = true
        movieListVC.searchCanPage = false
        XCTAssertTrue(movieListVC.hasNextPage())
    }
    
    func test_hasNextPage_returnsSearchCanPageWhenSearching() {
        movieListVC.currentSearchQuery = "searching"
        movieListVC.canPage = true
        movieListVC.searchCanPage = false
        XCTAssertFalse(movieListVC.hasNextPage())
    }
    
    // MARK: - isSearchActive
    
    func test_isSearchActive_returnsFalseWhenNotSearching() {
        movieListVC.currentSearchQuery = nil
        XCTAssertFalse(movieListVC.isSearchActive())
    }
    
    func test_isSearchActive_returnsTrueWhenSearching() {
        movieListVC.currentSearchQuery = "searching"
        XCTAssertTrue(movieListVC.isSearchActive())
    }
    
    // MARK: - updateMovieList
    
    func test_updateMovieList_updatesRightParameters() {
        let response = MoviesAPIResponse(page: 1, totalResults: 100, totalPages: 100, results: TestHelper.generateMovieArray(numberOfItems: 1)!)
        movieListVC.canPage = false
        movieListVC.pageNumber = 32
        movieListVC.movies = []
        movieListVC.updateMovieList(movieAPIresponse: response)
        XCTAssertEqual(movieListVC.movies.count, 1)
        XCTAssertEqual(movieListVC.pageNumber, 33)
        XCTAssertTrue(movieListVC.canPage)
    }
    
    // MARK: - updateSearchList
    
    func test_updateSearchList_updatesRightParameters() {
        let response = MoviesAPIResponse(page: 1, totalResults: 100, totalPages: 100, results: TestHelper.generateMovieArray(numberOfItems: 1)!)
        movieListVC.searchCanPage = false
        movieListVC.searchPageNumber = 32
        movieListVC.searchMovies = []
        movieListVC.updateSearchList(movieAPIresponse: response)
        XCTAssertEqual(movieListVC.searchMovies.count, 1)
        XCTAssertEqual(movieListVC.searchPageNumber, 33)
        XCTAssertTrue(movieListVC.searchCanPage)
    }
    
    // MARK: - Configuration
    
    func test_configureEmptyStateView() {
        movieListVC.loadViewIfNeeded()
        movieListVC.configureEmptyStateView()
        XCTAssertTrue(movieListVC.emptyStateView.isHidden)
        XCTAssertEqual(movieListVC.emptyStateView.superview, movieListVC.view)
    }
    
    func test_configureSearchController() {
        movieListVC.loadViewIfNeeded()
        movieListVC.configureSearchController()
        XCTAssertFalse(movieListVC.searchController.obscuresBackgroundDuringPresentation)
        XCTAssertFalse(movieListVC.searchController.dimsBackgroundDuringPresentation)
    }
    
    // MARK: - cellForRowAt
    
    func test_cellForRowAt_returns_loadingCellForSectionOne() {
        movieListVC.movies = TestHelper.generateMovieArray(numberOfItems: 1)!
        movieListVC.canPage = true
        movieListVC.viewDidLoad()
        let cell = movieListVC.tableView(movieListVC.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
        XCTAssertTrue(cell.classForCoder == LoadingCell.classForCoder())
    }
    
    func test_cellForRowAt_returns_MovieCellForSectionZero() {
        movieListVC.movies = TestHelper.generateMovieArray(numberOfItems: 1)!
        movieListVC.canPage = true
        movieListVC.viewDidLoad()
        let cell = movieListVC.tableView(movieListVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell.classForCoder == MovieListCell.classForCoder())
    }
}
