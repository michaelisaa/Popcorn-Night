
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
    let movie = TestHelper.generateMovie()!
    
    override func setUp() {
        super.setUp()
        movieDetailsCell.frame = CGRect(x: 0, y: 0, width: 350, height: 120)
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
