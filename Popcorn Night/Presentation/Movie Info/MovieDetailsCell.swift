//
//  MovieDetailsCell.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 20/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

enum MovieDetailsCellType {
    case Summary
    case Genres
    case Overview
    case Revenue
    case HomePageLink
}

class MovieDetailsCell: UITableViewCell {
    let titleLabel = UILabel(forAutoLayout: ())
    let infoLabel = UILabel(forAutoLayout: ())
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
        backgroundColor = UIColor.white.withAlphaComponent(0.75)
        configureTitleLabel()
        configureInfoLabel()
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: contentPadding)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: contentPadding)
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
    }
    
    func configureInfoLabel() {
        contentView.addSubview(infoLabel)
        infoLabel.autoPinEdge(toSuperviewEdge: .left, withInset: contentPadding)
        infoLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentPadding)
        infoLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: contentPadding)
        infoLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: contentPadding)
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        infoLabel.textColor = .black
    }
    
    func configure(movie: Movie, type: MovieDetailsCellType) {
        infoLabel.textColor = .black
        switch type {
            case .Summary:
                configureForSummary(movie)
            case .Genres:
                configureForGeneres(movie)
            case .Overview:
                configureForOverview(movie)
            case .Revenue:
                configureForRevenue(movie)
            case .HomePageLink:
                configureForHomePage(movie)
        }
    }
    
    func configureForSummary(_ movie: Movie) {
        titleLabel.text = nil
        let seperator = "  ∙  "
        var labelText = movie.releaseYear()
        if  let runtime = movie.runtime {
            labelText = "\(labelText)\(seperator)\(runtime) min"
        }

        if let language = movie.originalLanguage {
            labelText = "\(labelText)\(seperator)\(language.lowercased())"
        }
        
        if movie.voteAverage > 0.0 {
            labelText = "\(labelText)\(seperator)\(movie.voteAverage) / 10"
        }
        infoLabel.text = labelText
    }
    
    func configureForGeneres(_ movie: Movie) {
        titleLabel.text = "Genres"
        infoLabel.text = movie.genresString()
    }
    
    func configureForOverview(_ movie: Movie) {
        titleLabel.text = "Overview"
        infoLabel.text = movie.overview
    }
    
    func configureForRevenue(_ movie: Movie) {
        titleLabel.text = "Revenue"
        
        let revenue = NumberFormatter.localizedString(from: NSNumber(value: movie.revenue ?? 0), number: NumberFormatter.Style.decimal)
        infoLabel.text = "$ \(revenue)"
    }
    
    func configureForHomePage(_ movie: Movie) {
        titleLabel.text = "Home Page"
        infoLabel.text = movie.homepage
        infoLabel.textColor = .blue
    }
    
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}
