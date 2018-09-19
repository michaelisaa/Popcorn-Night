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
    let movie: Movie?
    let overviewLabel = UILabel(forAutoLayout: ())
    let posterImageView = UIImageView(forAutoLayout: ())
    
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
        configureTitleLabel()
        configurePosterImageView()
        configureOverviewLabel()
    }
    
    // MARK: - Configure Views
    
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
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func configureOverviewLabel() {
        view.addSubview(overviewLabel)
        overviewLabel.text = movie?.overview
        overviewLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .black
        overviewLabel.autoPinEdge(toSuperviewSafeArea: .left)
        overviewLabel.autoPinEdge(toSuperviewSafeArea: .right)
        overviewLabel.autoPinEdge(.top, to: .bottom, of: posterImageView)
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
            posterImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            posterImageView.image = placeholderImage
        }
    }
    
    func urlForMoviePoster() -> URL? {
        guard let backdropPath = movie?.backdropPath else { return nil }
        let urlString = "https://image.tmdb.org/t/p/w780" + backdropPath
        return URL(string: urlString)
    }
}
