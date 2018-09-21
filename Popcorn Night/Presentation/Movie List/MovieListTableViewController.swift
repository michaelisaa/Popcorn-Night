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
    var currentSearchQuery: String?
    var canPage = false
    var pageNumber = 1
    let searchController = UISearchController(searchResultsController: nil)
    var searchMovies = [Movie]()
    var searchPageNumber = 1
    var searchCanPage = false
    let emptyStateView = MovieListEmptyStateView(forAutoLayout: ())
    var timer: Timer?
    let timerLimit = 0.3
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavbar()
        configureTableView()
        configureSearchController()
        configureEmptyStateView()
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
    
    // MARK: - Configuration
    
    func configureEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.autoPinEdgesToSuperviewEdges()
        emptyStateView.isHidden = true
        view.bringSubview(toFront: emptyStateView)
    }
    
    func configureNavbar() {
        navigationItem.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        if movies.count == 0, let moviesFromStore = MovieStore.shared.loadMoviesFromStore() {
            self.movies = moviesFromStore
            self.canPage = true
            self.pageNumber = 2
        } else {
            APICLient.listRecentMovies(page: pageNumber, success: { (movieAPIResponse) in
                self.updateMovieList(movieAPIresponse: movieAPIResponse)
            }) { (error) in
                self.emptyStateView.isHidden = false
                self.emptyStateView.configure(state: .Error)
            }
        }
    }
    
    @objc func fetchMovieSearchResults() {
        if let searchQuery = searchController.searchBar.text, searchQuery.count > 0 {
            if let currentSearchQuery = currentSearchQuery, currentSearchQuery != searchQuery {
                searchPageNumber = 1
                searchMovies.removeAll()
                self.emptyStateView.isHidden = false
                self.emptyStateView.configure(state: .Loading)
            }
            currentSearchQuery = searchQuery
            APICLient.searchMovies(query: searchQuery, page: searchPageNumber, success: { (movieAPIResponse) in
                self.updateSearchList(movieAPIresponse: movieAPIResponse)
            }) { (_) in
                self.emptyStateView.isHidden = false
                self.emptyStateView.configure(state: .Error)
            }
        } else {
            configureEmptyViewState()
        }
    }
    
    func updateMovieList(movieAPIresponse: MoviesAPIResponse) {
        movies += movieAPIresponse.results
        if pageNumber == 1 {
            MovieStore.shared.store(movies: movies)
        }
        pageNumber += 1
        canPage = pageNumber <= movieAPIresponse.totalPages
        tableView.reloadData()
    }
    
    func updateSearchList(movieAPIresponse: MoviesAPIResponse) {
        searchPageNumber += 1
        searchMovies += movieAPIresponse.results
        searchCanPage = searchPageNumber <= movieAPIresponse.totalPages
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hasNextPage() ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let rowCount = moviesToDisplay().count
            if rowCount == 0 {
                configureEmptyViewState()
            } else {
                self.emptyStateView.isHidden = true
            }
            return rowCount
        }
        return section == 0 ? moviesToDisplay().count : 1
    }
    
    func configureEmptyViewState() {
        if isSearchActive() {
            self.emptyStateView.isHidden = false
            self.emptyStateView.configure(state: .EmptySearch)
        } else if searchController.isActive {
            self.emptyStateView.isHidden = false
            self.emptyStateView.configure(state: .InitialSearch)
        }
    }
    
    func moviesToDisplay() -> [Movie] {
        return isSearchActive() ? searchMovies : movies
    }
    
    func hasNextPage() -> Bool {
        return isSearchActive() ? searchCanPage : canPage
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
        if indexPath.section == 1 && hasNextPage() {
            if isSearchActive() {
                fetchMovieSearchResults()
            } else {
                fetchPopularMovies()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectedMovie = moviesToDisplay()[indexPath.row]
            let movieInfoVC = MovieInfoViewController(movie: selectedMovie)
            navigationController?.pushViewController(movieInfoVC, animated: true)
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        if let searchQuery = searchController.searchBar.text, searchQuery.count > 0 {
             timer = Timer.scheduledTimer(timeInterval: timerLimit, target: self, selector: #selector(fetchMovieSearchResults), userInfo: nil, repeats: false)
            emptyStateView.isHidden = false
            emptyStateView.configure(state: .Loading)
        }
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentSearchQuery = nil
        emptyStateView.isHidden = true
        tableView.reloadData()
    }
}
