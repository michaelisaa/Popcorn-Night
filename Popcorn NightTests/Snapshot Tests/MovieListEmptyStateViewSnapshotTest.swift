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

class MovieListEmptyStateViewSnapshotTest: FBSnapshotTestCase {
    let emptyStateView = MovieListEmptyStateView()
    
    override func setUp() {
        super.setUp()
        emptyStateView.frame = CGRect(x: 0, y: 0, width: 375, height: 500)
        emptyStateView.backgroundColor = .white
    }
    
    func test_configure_withLoadingState() {
        emptyStateView.configure(state: .Loading)
        FBSnapshotVerifyView(emptyStateView)
    }
    
    func test_configure_withErrorState() {
        emptyStateView.configure(state: .Error)
        FBSnapshotVerifyView(emptyStateView)
    }
    
    func test_configure_withInitialSearchState() {
        emptyStateView.configure(state: .InitialSearch)
        FBSnapshotVerifyView(emptyStateView)
    }
    
    func test_configure_withEmptySearchState() {
        emptyStateView.configure(state: .EmptySearch)
        FBSnapshotVerifyView(emptyStateView)
    }
    
}
