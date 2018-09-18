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

class LoadingCellSnapshotTest: FBSnapshotTestCase {
    let loadingCell = LoadingCell()
    
    override func setUp() {
        super.setUp()
        loadingCell.backgroundColor = .white
        loadingCell.frame = CGRect(x: 0, y: 0, width: 350, height: 100)
    }
    
    func test_loadingCell() {
        loadingCell.startAnimating()
        FBSnapshotVerifyView(loadingCell)
    }
    
}
