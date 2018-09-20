
//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 20/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import FBSnapshotTestCase
import UIKit

@testable import Popcorn_Night

class MovieDetailsCellSnapshotTest: FBSnapshotTestCase {
    
    let movieDetailsCell = MovieDetailsCell()
    let movie = Movie(posterPath: nil, backdropPath: nil, overview: "Overview test", releaseDate: "2018-01-03", movieId: 0, title: "title", popularity: 0, voteAverage: 8.9, originalLanguage: "En", voteCount: 1, budget: 1, homepage: "www.google.com", revenue: 1000, runtime: 180, tagline: "f", genres: [Genre(genreId: 1, name: "Action")], genreIds: nil)
    
    override func setUp() {
        super.setUp()
    }
    
    func test_configure_forSummary() {
        movieDetailsCell.configure(movie: movie, type: .Summary)
        FBSnapshotVerifyView(movieDetailsCell)
    }
    
    func test_configure_forOverview() {
        movieDetailsCell.configure(movie: movie, type: .Overview)
        FBSnapshotVerifyView(movieDetailsCell)
    }
    
    func test_configure_forGenres() {
        movieDetailsCell.configure(movie: movie, type: .Genres)
        FBSnapshotVerifyView(movieDetailsCell)
    }
    
    func test_configure_forRevenue() {
        movieDetailsCell.configure(movie: movie, type: .Revenue)
        FBSnapshotVerifyView(movieDetailsCell)
    }
    
    func test_configure_forHomePage() {
        movieDetailsCell.configure(movie: movie, type: .HomePageLink)
        FBSnapshotVerifyView(movieDetailsCell)
    }
}
