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
    
    // MARK: - moviesToDisplay
    
    func test_moviesToDisplay_returnsMoviesListWhenNotSearching() {
        let movieA = Movie(posterPath: nil, overview: "a", releaseDate: "a", id: 0, title: "a", popularity: 0, voteAverage: 0)
        let movieB = Movie(posterPath: nil, overview: "b", releaseDate: "b", id: 0, title: "b", popularity: 0, voteAverage: 0)
        let movieC = Movie(posterPath: nil, overview: "c", releaseDate: "c", id: 0, title: "c", popularity: 0, voteAverage: 0)
        movieListVC.currentSearchQuery = nil
        movieListVC.movies = [movieA, movieB]
        movieListVC.searchMovies = [movieC]
        XCTAssertEqual(movieListVC.moviesToDisplay().count, 2)
    }
    
    func test_moviesToDisplay_returnsSearchResultsWhenSearching() {
        let movieA = Movie(posterPath: nil, overview: "a", releaseDate: "a", id: 0, title: "a", popularity: 0, voteAverage: 0)
        let movieB = Movie(posterPath: nil, overview: "b", releaseDate: "b", id: 0, title: "b", popularity: 0, voteAverage: 0)
        let movieC = Movie(posterPath: nil, overview: "c", releaseDate: "c", id: 0, title: "c", popularity: 0, voteAverage: 0)
        movieListVC.currentSearchQuery = nil
        movieListVC.movies = [movieA, movieB]
        movieListVC.searchMovies = [movieC]
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
        let movieA = Movie(posterPath: nil, overview: "a", releaseDate: "a", id: 0, title: "a", popularity: 0, voteAverage: 0)
        let response = MoviesAPIResponse(page: 1, totalResults: 100, totalPages: 100, results: [movieA])
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
        let movieA = Movie(posterPath: nil, overview: "a", releaseDate: "a", id: 0, title: "a", popularity: 0, voteAverage: 0)
        let response = MoviesAPIResponse(page: 1, totalResults: 100, totalPages: 100, results: [movieA])
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
}
