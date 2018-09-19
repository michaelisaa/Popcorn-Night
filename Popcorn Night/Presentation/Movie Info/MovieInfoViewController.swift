//
//  MovieInfoViewController.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 19/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

class MovieInfoViewController: UIViewController {
    let scrollView = UIScrollView(forAutoLayout: ())
    let overviewLabel = UILabel(forAutoLayout: ())
    let posterImageView = UIImageView(forAutoLayout: ())
    let emptyStateView = MovieListEmptyStateView(forAutoLayout: ())
    let releaseAndRuntimeLabel = UILabel(forAutoLayout: ())
    let movieId: Int?
    var movie: Movie?
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        movieId = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureScrollView()
        configureEmptyStateView()
        fetchMovieDetails()
    }
    
    func fetchMovieDetails() {
        if let movieId = movieId {
            emptyStateView.configure(state: .Loading)
            emptyStateView.isHidden = false
            APICLient.getMovieDetails(movieId: movieId, success: { (movieInfo) in
                self.movie = movieInfo
                self.emptyStateView.isHidden = true
                self.configureMovieInfoView()
            }) { (_) in
                
            }
        } else {
            emptyStateView.configure(state: .Error)
            emptyStateView.isHidden = false
        }
    }
    
    // MARK: - Configure Views
    
    func configureMovieInfoView() {
        configureTitleLabel()
        configurePosterImageView()
        configureOverviewLabel()
        configureReleaseAndRuntimeLabel()
    }
    
    func configureEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.autoPinEdgesToSuperviewEdges()
        emptyStateView.isHidden = true
        view.bringSubview(toFront: emptyStateView)
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
    }
    
    func configureTitleLabel() {
//        view.addSubview(titleLabel)
//        titleLabel.text = movie?.title
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
//        titleLabel.textColor = .white
//        titleLabel.autoPinEdge(toSuperviewSafeArea: .left)
//        titleLabel.autoPinEdge(toSuperviewSafeArea: .right)
//        titleLabel.autoPinEdge(toSuperviewSafeArea: .top)
        navigationItem.title = movie?.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureOverviewLabel() {
        scrollView.addSubview(overviewLabel)
        overviewLabel.text = movie?.overview
        overviewLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .black
        overviewLabel.autoPinEdge(toSuperviewSafeArea: .left)
        overviewLabel.autoPinEdge(toSuperviewSafeArea: .right)
        overviewLabel.autoPinEdge(.top, to: .bottom, of: posterImageView)
    }
    
    func configurePosterImageView() {
        scrollView.addSubview(posterImageView)
        posterImageView.autoPinEdge(toSuperviewEdge: .left)
        posterImageView.autoPinEdge(toSuperviewEdge: .top)
        posterImageView.autoPinEdge(toSuperviewEdge: .right)
        posterImageView.autoSetDimension(.height, toSize: 300)
        posterImageView.contentMode = .scaleAspectFill
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
    
    func configureReleaseAndRuntimeLabel() {
        
        scrollView.addSubview(releaseAndRuntimeLabel)
        releaseAndRuntimeLabel.insetsLayoutMarginsFromSafeArea = true
        releaseAndRuntimeLabel.autoPinEdge(toSuperviewEdge: .left)
        releaseAndRuntimeLabel.autoPinEdge(toSuperviewEdge: .right)
        releaseAndRuntimeLabel.autoPinEdge(.bottom, to: .bottom, of: posterImageView)
        releaseAndRuntimeLabel.autoSetDimension(.height, toSize: 40)
        var labelText = String(movie!.releaseDate.split(separator: "-").first!)
        if  let runtime = movie!.runtime {
            labelText = labelText + " \(runtime)min"
        }
        releaseAndRuntimeLabel.text = labelText
        releaseAndRuntimeLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        releaseAndRuntimeLabel.textColor = .white
        releaseAndRuntimeLabel.backgroundColor = .black
        releaseAndRuntimeLabel.alpha = 0.75
    }
    
    func urlForMoviePoster() -> URL? {
        guard let backdropPath = movie?.backdropPath else { return nil }
        let urlString = "https://image.tmdb.org/t/p/w780" + backdropPath
        return URL(string: urlString)
    }
}
