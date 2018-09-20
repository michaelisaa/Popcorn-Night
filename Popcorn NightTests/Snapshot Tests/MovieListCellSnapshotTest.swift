//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import FBSnapshotTestCase
import UIKit

@testable import Popcorn_Night

class MovieListCellSnapshotTest: FBSnapshotTestCase {
    
    let movieCell = MovieListCell()
    
    override func setUp() {
        super.setUp()
        movieCell.frame = CGRect(x: 0, y: 0, width: 350, height: 100)
        movieCell.backgroundColor = .white
    }
    
    func test_configureMovie_withShortTitle_shortOverview() {
        let movie = TestHelper.generateMovie(title: "Title", overview: "Overview")
        movieCell.configure(movie: movie)
        FBSnapshotVerifyView(movieCell)
    }
    
    func test_configureMovie_withLongTitle_shortOverview() {
        let longTitle = "Very long title that should be way too long for the label to show"
        let movie = TestHelper.generateMovie(title: longTitle, overview: "Overview")
        movieCell.configure(movie: movie)
        FBSnapshotVerifyView(movieCell)
    }
    
    func test_configureMovie_withLongTitle_longOverview() {
        let longTitle = "Very long title that should be way too long for the label to show"
        let longOverview = """
                            Very long overview that should be way too long for the label
                            to show and should be on multiple lines. It should keep going
                            for a while
                           """
        let movie = TestHelper.generateMovie(title: longTitle, overview: longOverview)
        movieCell.configure(movie: movie)
        FBSnapshotVerifyView(movieCell)
    }
}
