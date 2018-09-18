//
//  ViewController.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 17/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        APICLient.searchMovies(query: "Shrek", page: 1, success: { (moviesAPIResponse) in
            let movies = moviesAPIResponse.results
            print("Count: ", movies.count)
        }, failure: {(err) in
            
        })
//        APICLient.listRecentMovies(page: 1, success: { (recentMoviesResponse) in
//            let movies = recentMoviesResponse.results
//            print("Count: ", movies.count)
//        }) { (err) in
//
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

