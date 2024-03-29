//
//  MovieListTableViewController.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

class MovieListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, EmptyViewStateDelegate {
    let tableView = UITableView()
    let refreshController = UIRefreshControl()
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
    let emptyStateView = EmptyStateView(forAutoLayout: ())
    var timer: Timer?
    let timerLimit = 0.3
    var movieGenres: [Int: Genre]?
    var refreshMovies = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGenresIfNeeded()
        getConfigIfNeeded()
        view.backgroundColor = .white
        configureNavbar()
        configureTableView()
        configureSearchController()
        configureEmptyStateView()
        self.emptyStateView.isHidden = false
        self.emptyStateView.configure(state: .Loading)
        fetchPopularMovies()
    }
    
    func getConfigIfNeeded() {
        if MovieStore.shared.loadConfigFromStore() == nil {
            APIClient.getAPIConfig(success: { (config) in
                MovieStore.shared.store(config: config)
                self.tableView.reloadData()
            }) { (_) in
            }
        }
    }
    
    func getGenresIfNeeded() {
        if MovieStore.shared.loadGenresFromStore() == nil {
            APIClient.getGenreList(success: { (genres) in
                MovieStore.shared.store(genres: genres)
                self.configureMovieGenres()
                self.tableView.reloadData()
            }) { (_) in 
            }
        } else {
            configureMovieGenres()
        }
    }
    
    func configureMovieGenres() {
        if let genres = MovieStore.shared.loadGenresFromStore() {
            self.movieGenres = [Int :Genre]()
            for genre in genres {
                self.movieGenres![genre.genreId] = genre
            }
            self.movies = self.addGenresToMovies(movies: self.movies)
        }
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
        emptyStateView.delegate = self
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
        tableView.tableFooterView = UIView()
        configureRefreshControl()
    }
    
    func configureRefreshControl() {
        refreshController.tintColor = .blue
        refreshController.addTarget(self, action: #selector(refreshPopularMovies), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    @objc func refreshPopularMovies() {
        refreshMovies = true
        pageNumber = 1
        fetchPopularMovies()
    }
    
    // MARK: - Datasource
    
    func fetchPopularMovies() {
        if movies.count == 0, let moviesFromStore = MovieStore.shared.loadMoviesFromStore() {
            self.movies = self.addGenresToMovies(movies: moviesFromStore)
            self.canPage = true
            self.pageNumber = 2
            self.emptyStateView.isHidden = true
            self.tableView.reloadData()
        } else {
            APIClient.listRecentMovies(page: pageNumber, success: { (movieAPIResponse) in
                self.emptyStateView.isHidden = true
                self.updateMovieList(movieAPIresponse: movieAPIResponse)
            }) { (error) in
                if self.movies.count == 0 {
                    self.emptyStateView.isHidden = false
                    self.emptyStateView.configure(state: .Error)
                }
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
            APIClient.searchMovies(query: searchQuery, page: searchPageNumber, success: { (movieAPIResponse) in
                self.updateSearchList(movieAPIresponse: movieAPIResponse)
            }) { (_) in
                self.emptyStateView.isHidden = false
                self.emptyStateView.configure(state: .Error)
            }
        } else {
            configureEmptyViewState()
        }
    }
    
    func addGenresToMovies(movies: [Movie]) -> [Movie] {
        var updatedMovies = movies
        if let movieGenres = movieGenres {
            for index in updatedMovies.indices {
                var movie = movies[index]
                if let genreIds = movie.genreIds {
                    var genres = [Genre]()
                    for genreId in genreIds {
                        if let genre = movieGenres[genreId] {
                            genres.append(genre)
                        }
                    }
                    movie.genres = genres
                    updatedMovies[index] = movie
                }
            }
        }
        return updatedMovies
    }
    
    func updateMovieList(movieAPIresponse: MoviesAPIResponse) {
        let newMovies = addGenresToMovies(movies: movieAPIresponse.results)
        if refreshMovies {
            movies = newMovies
            refreshMovies = false
            refreshController.endRefreshing()
        } else {
            movies += newMovies
        }
        if pageNumber == 1 {
            MovieStore.shared.store(movies: newMovies)
        }
        pageNumber += 1
        canPage = pageNumber <= movieAPIresponse.totalPages
        tableView.reloadData()
    }
    
    func updateSearchList(movieAPIresponse: MoviesAPIResponse) {
        searchPageNumber += 1
        let newMovies = addGenresToMovies(movies: movieAPIresponse.results)
        searchMovies += newMovies
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
        if let searchQuery = searchController.searchBar.text, searchQuery.count > 0, currentSearchQuery != searchQuery {
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
    
    // MARK: - EmptyViewStateDelegate
    
    func retryAction() {
        emptyStateView.configure(state: .Loading)
        if let query = currentSearchQuery, query.count > 0 {
            fetchMovieSearchResults()
        } else {
            fetchPopularMovies()
        }
    }
}
