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
        movieCell.frame = CGRect(x: 0, y: 0, width: 350, height: 150)
        movieCell.backgroundColor = .white
    }
    
    func test_configureMovie_withoutGenre() {
        let movie = TestHelper.generateMovie()!
        movieCell.configure(movie: movie)
        FBSnapshotVerifyView(movieCell)
    }
    
    func test_configureMovie_withGenre() {
        var movie = TestHelper.generateMovie()!
        movie.genres = TestHelper.generateGenreArray(numberOfItems: 1)
        movieCell.configure(movie: movie)
        FBSnapshotVerifyView(movieCell)
    }
    
    func test_configureMovie_withManyGenres() {
        var movie = TestHelper.generateMovie()!
        movie.genres = TestHelper.generateGenreArray(numberOfItems: 8)
        movieCell.configure(movie: movie)
        FBSnapshotVerifyView(movieCell)
    }
}
