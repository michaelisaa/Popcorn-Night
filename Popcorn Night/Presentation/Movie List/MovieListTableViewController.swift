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
    var currentSearchQuery: String?
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
        fetchPopularMovies()
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
    
    func fetchPopularMovies() {
        APICLient.listRecentMovies(page: pageNumber, success: { (movieAPIResponse) in
            self.updateMovieList(movieAPIresponse: movieAPIResponse)
        }) { (error) in
            
        }
    }
    
    func fetchMovieSearchResults() {
        if let searchQuery = searchController.searchBar.text {
            if let currentSearchQuery = currentSearchQuery, currentSearchQuery != searchQuery {
                searchPageNumber = 1
                searchMovies.removeAll()
            }
            currentSearchQuery = searchQuery
            APICLient.searchMovies(query: searchQuery, page: searchPageNumber, success: { (movieAPIResponse) in
                self.updateSearchList(movieAPIresponse: movieAPIResponse)
            }) { (_) in
                
            }
        }
    }
    
    func updateMovieList(movieAPIresponse: MoviesAPIResponse) {
        pageNumber += 1
        canPage = pageNumber <= movieAPIresponse.totalPages
        movies += movieAPIresponse.results
        tableView.reloadData()
    }
    
    func updateSearchList(movieAPIresponse: MoviesAPIResponse) {
        searchPageNumber += 1
        searchMovies += movieAPIresponse.results
        canPage = searchPageNumber <= movieAPIresponse.totalPages
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return canPage ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? moviesToDisplay().count : 1
    }
    
    func moviesToDisplay() -> [Movie] {
        return isSearchActive() ? searchMovies : movies
    }
    
    func isSearchActive() -> Bool {
        if let currentSearchQuery = currentSearchQuery {
            return currentSearchQuery.count > 0
        }
        return false
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
            if isSearchActive() {
                fetchMovieSearchResults()
            } else {
                fetchPopularMovies()
            }
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        fetchMovieSearchResults()
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentSearchQuery = nil
        tableView.reloadData()
    }
    
}
