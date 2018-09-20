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
    let scrollContentView = UIView(forAutoLayout: ())
    let overviewLabel = UILabel(forAutoLayout: ())
    let genreLabel = UILabel(forAutoLayout: ())
    let revenueLabel = UILabel(forAutoLayout: ())
    let posterImageView = UIImageView(forAutoLayout: ())
    let emptyStateView = MovieListEmptyStateView(forAutoLayout: ())
    let movieId: Int?
    var movie: Movie?
    let contentInset:CGFloat = 10
    
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
                self.emptyStateView.configure(state: .Error)
                self.emptyStateView.isHidden = false
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
        configureGenreLabel()
        configureOverviewLabel()
        configureReleaseAndRuntimeLabel()
        configureRevenueLabel()
        configureHomepageLinkeLabel()
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
        scrollView.addSubview(scrollContentView)
        scrollContentView.autoPinEdgesToSuperviewEdges()
        scrollContentView.autoMatch(.width, to: .width, of: scrollView, withOffset: 0)
        scrollContentView.autoMatch(.height, to: .height, of: scrollView, withOffset: 0)
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
    
    func configureGenreLabel() {
        scrollContentView.addSubview(genreLabel)
        genreLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        genreLabel.numberOfLines = 0
        genreLabel.textColor = .black
        genreLabel.autoPinEdge(.top, to: .bottom, of: posterImageView, withOffset: contentInset)
        genreLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: contentInset)
        genreLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: contentInset)
        if let genres = movie?.genres {
            genreLabel.text =  genres.map { (genre) -> String in
                genre.name!
            }.joined(separator: " | ")
        }
    }
    
    func configureOverviewLabel() {
        scrollContentView.addSubview(overviewLabel)
        overviewLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .black
        overviewLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: contentInset)
        overviewLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: contentInset)
        overviewLabel.autoPinEdge(.top, to: .bottom, of: genreLabel, withOffset: contentInset)
        overviewLabel.text = movie?.overview
    }
    
    func configurePosterImageView() {
        scrollContentView.addSubview(posterImageView)
        posterImageView.autoPinEdge(toSuperviewEdge: .left)
        posterImageView.autoPinEdge(toSuperviewEdge: .top)
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
    
    func configureReleaseAndRuntimeLabel() {
        let ratingsLabel = UILabel(forAutoLayout: ())
        let releaseAndRuntimeLabel = UILabel(forAutoLayout: ())
        let backgroundView = UIView(forAutoLayout: ())
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.75
        scrollContentView.addSubview(backgroundView)
        backgroundView.autoPinEdge(toSuperviewEdge: .left)
        backgroundView.autoPinEdge(toSuperviewEdge: .right)
        backgroundView.autoPinEdge(.bottom, to: .bottom, of: posterImageView)
        backgroundView.autoSetDimension(.height, toSize: 40)
        var labelText = String(movie!.releaseDate.split(separator: "-").first!)
        if  let runtime = movie!.runtime {
            labelText = "\(labelText)  ∙  \(runtime) min"
        }
        
        if let language = movie?.originalLanguage {
            labelText = "\(labelText)  ∙  \(language.uppercased())"
        }
        releaseAndRuntimeLabel.text = labelText
        releaseAndRuntimeLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        releaseAndRuntimeLabel.textColor = .white
        backgroundView.addSubview(releaseAndRuntimeLabel)
        backgroundView.addSubview(ratingsLabel)
        releaseAndRuntimeLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsetsMake(0, contentInset, 0, 0), excludingEdge: .right)
        ratingsLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsetsMake(0, 0, 0, contentInset), excludingEdge: .left)
        ratingsLabel.autoPinEdge(.left, to: .right, of: releaseAndRuntimeLabel)
        ratingsLabel.textAlignment = .right
        ratingsLabel.textColor = .white
        if let voteAverage = movie?.voteAverage, voteAverage > 0.0 {
            ratingsLabel.text = "\(voteAverage) / 10 ⭐️"
        }
    }
    
    func configureRevenueLabel() {
        scrollContentView.addSubview(revenueLabel)
        revenueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        revenueLabel.numberOfLines = 1
        revenueLabel.textColor = .black
        revenueLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: contentInset)
        revenueLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: contentInset)
        revenueLabel.autoPinEdge(.top, to: .bottom, of: overviewLabel, withOffset: contentInset)
        if let revenue = movie?.revenue, revenue > 0 {
            revenueLabel.text = "$\(revenue)"
        }
    }
    
    func configureHomepageLinkeLabel() {
        
        let homePageLinkTextView = UITextView(forAutoLayout: ())
        homePageLinkTextView.isEditable = false
        homePageLinkTextView.dataDetectorTypes = .link
        scrollContentView.addSubview(homePageLinkTextView)
        homePageLinkTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        homePageLinkTextView.textColor = .black
        homePageLinkTextView.tintColor = .blue
        homePageLinkTextView.autoPinEdge(toSuperviewSafeArea: .left, withInset: contentInset)
        homePageLinkTextView.autoPinEdge(toSuperviewSafeArea: .right, withInset: contentInset)
        homePageLinkTextView.autoPinEdge(.top, to: .bottom, of: revenueLabel, withOffset: contentInset)
        homePageLinkTextView.autoSetDimension(.height, toSize: 30)
        if let homeLink = movie?.homepage {
            homePageLinkTextView.text = homeLink
        }
    }
    
    func urlForMoviePoster() -> URL? {
        guard let backdropPath = movie?.backdropPath else { return nil }
        let urlString = "https://image.tmdb.org/t/p/w780" + backdropPath
        return URL(string: urlString)
    }
}
