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
    
    func test_configureMovie() {
        let movie = TestHelper.generateMovie()!
        movieCell.configure(movie: movie)
        FBSnapshotVerifyView(movieCell)
    }
}
