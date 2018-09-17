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
        
        APICLient.getRecentMovies(success: { (data) in
            print("Hey")
        }) { (err) in
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

