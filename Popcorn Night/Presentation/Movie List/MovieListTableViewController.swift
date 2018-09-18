//
//  MovieListTableViewController.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

class MovieListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let cellIdentifier = "movieCellIdentifier"
    let loadingCellIdentifier = "loadingCellIdentifier"
    var movies = [Movie]()
    var canPage = false
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        pageNumber = 1
        fetchMovies()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieListCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: loadingCellIdentifier)
        tableView.configureForAutoLayout()
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: - Datasource
    
    func fetchMovies() {
        APICLient.listRecentMovies(page: pageNumber, success: { (movieAPIresponse) in
            self.pageNumber += 1
            self.canPage =  self.pageNumber <= movieAPIresponse.totalPages
            self.movies += movieAPIresponse.results
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    // MARK: - UITableViewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return canPage ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? movies.count : 1
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return configureMovieCell(indexPath)
        } else {
            return configureLoadingCell(indexPath)
        }
    }
    
    func configureMovieCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let movieListCell = cell as? MovieListCell else {return cell}
        movieListCell.configure(movie: movies[indexPath.row])
        return cell
    }
    
    func configureLoadingCell(_ indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && canPage {
            fetchMovies()
        }
    }
}
