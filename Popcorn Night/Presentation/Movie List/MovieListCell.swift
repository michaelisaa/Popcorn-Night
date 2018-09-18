//
//  MovieListCell.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

class MovieListCell: UITableViewCell {
    let titleLabel = UILabel(forAutoLayout: ())
    let overviewLabel = UILabel(forAutoLayout: ())
    let labelTopPadding:CGFloat = 10
    let contentPadding:CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    func configureView() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: contentPadding)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: contentPadding)
        
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
    }
}
