//
//  MovieListTableViewController.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

class MovieListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    let tableView = UITableView()
    let cellIdentifier = "movieCellIdentifier"
    let loadingCellIdentifier = "loadingCellIdentifier"
    var movies = [Movie]()
    var searchMovies = [Movie]()
    var searchPageNumber = 1
    var canPage = false
    var pageNumber = 1
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        configureTableView()
        configureSearchController()
        navigationItem.hidesSearchBarWhenScrolling = true
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
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
        return section == 0 ? moviesToDisplay().count : 1
    }
    
    func moviesToDisplay() -> [Movie] {
        return searchController.searchBar.text!.count > 0 ? searchMovies : movies
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
        movieListCell.configure(movie: moviesToDisplay()[indexPath.row])
        return movieListCell
    }
    
    func configureLoadingCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath)
        guard let loadingCell = cell as? LoadingCell else {return cell}
        loadingCell.startAnimating()
        return loadingCell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && canPage {
            fetchMovies()
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            APICLient.searchMovies(query: searchText, page: 1, success: { (moviesAPIResponse) in
                self.searchPageNumber += 1
                self.canPage = self.pageNumber <= moviesAPIResponse.totalPages
                self.searchMovies = moviesAPIResponse.results
                self.tableView.reloadData()
            }) { (_) in
                
            }
        }
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
}
