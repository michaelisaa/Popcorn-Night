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
    let posterImageView = UIImageView()
    let labelTopPadding:CGFloat = 10
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
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.autoPinEdge(toSuperviewEdge: .left, withInset: contentPadding)
        posterImageView.autoPinEdge(toSuperviewEdge: .top, withInset: contentPadding)
        posterImageView.autoSetDimensions(to: CGSize(width: posterImageViewHeight, height: posterImageViewHeight))
        posterImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: contentPadding)
        posterImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.autoPinEdge(.left, to: .right, of: posterImageView, withOffset: contentPadding)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        titleLabel.autoPinEdge(.top, to: .top, of: posterImageView)
        
        contentView.addSubview(overviewLabel)
        overviewLabel.numberOfLines = 3
        overviewLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        overviewLabel.autoPinEdge(.left, to: .left, of: titleLabel)
        overviewLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        overviewLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: labelTopPadding)
        overviewLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: contentPadding)
    }
    
    public func configure(movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
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
