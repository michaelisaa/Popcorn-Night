//
//  MovieListCell.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout
import AlamofireImage

class MovieListCell: UITableViewCell {
    let titleLabel = UILabel(forAutoLayout: ())
    let overviewLabel = UILabel(forAutoLayout: ())
    let releaseDateLabel = UILabel(forAutoLayout: ())
    let genreLabel = UILabel(forAutoLayout: ())
    let popularityLabel = UILabel(forAutoLayout: ())
    let posterImageView = UIImageView()
    let labelTopPadding:CGFloat = 5
    let contentPadding:CGFloat = 10
    let posterImageViewHeight:CGFloat = 80
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    func configureView() {
        configurePosterImageView()
        configureTitleLabel()
        configureReleaseDateLabel()
        configurePopularityLabel()
        configureGenreLabel()
        configureOverviewLabel()
    }
    
    func configurePosterImageView() {
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.autoPinEdge(toSuperviewEdge: .left, withInset: contentPadding)
        posterImageView.autoPinEdge(toSuperviewEdge: .top, withInset: contentPadding)
        posterImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: contentPadding)
        posterImageView.autoSetDimension(.width, toSize: posterImageViewHeight)
        posterImageView.contentMode = .scaleAspectFit
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.autoPinEdge(.left, to: .right, of: posterImageView, withOffset: contentPadding)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: contentPadding)
        titleLabel.autoSetDimension(.height, toSize: 20)
    }
    
    func configureReleaseDateLabel() {
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        releaseDateLabel.autoPinEdge(.left, to: .left, of: titleLabel)
        releaseDateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        releaseDateLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: labelTopPadding)
        releaseDateLabel.autoSetDimension(.height, toSize: 15)
    }
    
    func configurePopularityLabel() {
        contentView.addSubview(popularityLabel)
        popularityLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        popularityLabel.autoPinEdge(.top, to: .bottom, of: releaseDateLabel, withOffset: labelTopPadding)
        popularityLabel.autoPinEdge(.left, to: .left, of: titleLabel)
        popularityLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        popularityLabel.autoSetDimension(.height, toSize: 15)
    }
    
    func configureGenreLabel() {
        contentView.addSubview(genreLabel)
        genreLabel.numberOfLines = 2
        genreLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        genreLabel.autoPinEdge(.left, to: .left, of: titleLabel)
        genreLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        genreLabel.autoPinEdge(.top, to: .bottom, of: popularityLabel, withOffset: labelTopPadding)
    }
    
    func configureOverviewLabel() {
        contentView.addSubview(overviewLabel)
        overviewLabel.numberOfLines = 3
        overviewLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        overviewLabel.autoPinEdge(.left, to: .left, of: titleLabel)
        overviewLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        overviewLabel.autoPinEdge(.top, to: .bottom, of: genreLabel, withOffset: labelTopPadding)
        overviewLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: contentPadding)
    }
    
    public func configure(movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = movie.releaseYear()
        popularityLabel.text = "Popularity score: \(movie.popularity)"
        genreLabel.text = movie.genresString()
        let placeholderImage = UIImage(imageLiteralResourceName: "moviePlaceholderIcon")
        if let url = urlForMoviePoster(movie: movie) {
            posterImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            posterImageView.image = placeholderImage
        }
    }
    
    func urlForMoviePoster(movie: Movie) -> URL? {
        guard let posterPath = movie.posterPath else { return nil }
        let urlString = "https://image.tmdb.org/t/p/w185" + posterPath
        return URL(string: urlString)
    }
}
