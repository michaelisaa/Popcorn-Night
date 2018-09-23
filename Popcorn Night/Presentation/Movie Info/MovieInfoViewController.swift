//
//  MovieInfoViewController.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 19/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

class MovieInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(forAutoLayout: ())
    let posterImageView = UIImageView(forAutoLayout: ())
    let emptyStateView = MovieListEmptyStateView(forAutoLayout: ())
    var movie: Movie?
    let contentInset:CGFloat = 10
    var availableMovieDetails = [MovieDetailsCellType]()
    let cellIdentifier = "movieDetailsCell"
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        movie = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        configureEmptyStateView()
        configureNavbar()
        fetchMovieDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsetsMake(300, 0, view.safeAreaInsets.bottom, 0)
    }
    
    func fetchMovieDetails() {
        if let movie = movie {
            emptyStateView.configure(state: .Loading)
            emptyStateView.isHidden = false
            APICLient.getMovieDetails(movieId: movie.movieId, success: { (movieInfo) in
                self.movie = movieInfo
                self.emptyStateView.isHidden = true
                self.configureMovieInfo()
            }) { (_) in
                self.emptyStateView.configure(state: .Error)
                self.emptyStateView.isHidden = false
            }
        } else {
            emptyStateView.configure(state: .Error)
            emptyStateView.isHidden = false
        }
    }
    
    // MARK: - Configure Views
    
    func configureMovieInfo() {
        configurePosterImageView()
        availableMovieDetails.append(.Summary)
        if movie?.genres != nil {
            availableMovieDetails.append(.Genres)
        }
        availableMovieDetails.append(.Overview)
        if let revenue = movie?.revenue, revenue > 0 {
            availableMovieDetails.append(.Revenue)
        }
        if movie?.homepage != nil {
            availableMovieDetails.append(.HomePageLink)
        }
        tableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        tableView.reloadData()
    }
    
    func configureEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.autoPinEdgesToSuperviewEdges()
        emptyStateView.isHidden = true
        view.bringSubview(toFront: emptyStateView)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.register(MovieDetailsCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView.autoPinEdgesToSuperviewEdges()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    func configureNavbar() {
        navigationItem.title = movie?.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configurePosterImageView() {
        view.addSubview(posterImageView)
        posterImageView.autoPinEdge(toSuperviewEdge: .left)
        posterImageView.autoPinEdge(toSuperviewSafeArea: .top)
        posterImageView.autoPinEdge(toSuperviewEdge: .right)
        posterImageView.autoSetDimension(.height, toSize: 300)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        view.sendSubview(toBack: posterImageView)
        let placeholderImage = UIImage(imageLiteralResourceName: "moviePlaceholderIcon")
        if let url = urlForMoviePoster() {
            posterImageView.af_setImage(
                withURL: url,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
        } else {
            posterImageView.image = placeholderImage
        }
    }
    
    func urlForMoviePoster() -> URL? {
        guard let backdropPath = movie?.backdropPath else { return nil }
        guard let imageConfig = MovieStore.shared.loadConfigFromStore()?.imageConfig else {return nil}
        guard let backdropSize = imageConfig.movieBackdropSize() else {return nil}
        let urlString = "https://image.tmdb.org/t/p/\(backdropSize)" + backdropPath
        return URL(string: urlString)
    }
    
    // MARK: - Tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableMovieDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let movieDetailsCell = cell as? MovieDetailsCell else {return cell}
        movieDetailsCell.configure(movie: movie!, type: availableMovieDetails[indexPath.row])
        return movieDetailsCell
    }
}
