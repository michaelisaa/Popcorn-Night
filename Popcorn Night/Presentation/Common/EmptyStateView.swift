//
//  MovieListEmptyStateView.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

enum EmptyViewState {
    case Loading
    case InitialSearch
    case EmptySearch
    case Error
}

protocol EmptyViewStateDelegate {
    func retryAction()
}

class EmptyStateView: UIView {
    let activityIndicator = UIActivityIndicatorView(forAutoLayout: ())
    let activityIndicatorHeight:CGFloat = 40
    let titleLabel = UILabel(forAutoLayout: ())
    let retryButton = UIButton(forAutoLayout: ())
    let messageLabel = UILabel(forAutoLayout: ())
    let contentInset:CGFloat = 20
    var delegate: EmptyViewStateDelegate?
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        backgroundColor = .white
        configureTitleLabel()
        configureMessageLabel()
        configureRetryButton()
        configureActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Configuration

    func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: contentInset)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentInset)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: -20)
    }
    
    func configureMessageLabel() {
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        messageLabel.autoPinEdge(toSuperviewEdge: .left, withInset: contentInset)
        messageLabel.autoPinEdge(toSuperviewEdge: .right, withInset: contentInset)
        messageLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
    }
    
    func configureRetryButton() {
        addSubview(retryButton)
        retryButton.addTarget(self, action: #selector(didTouchRetryButton), for: .touchUpInside)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.autoPinEdge(toSuperviewEdge: .left, withInset: 120)
        retryButton.autoPinEdge(toSuperviewEdge: .right, withInset: 120)
        retryButton.autoSetDimension(.height, toSize: 40)
        retryButton.setTitleColor(.blue, for: .normal)
        retryButton.autoPinEdge(.top, to: .bottom, of: messageLabel, withOffset: 10)
        retryButton.layer.cornerRadius = 20
        retryButton.clipsToBounds = true
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    @objc func didTouchRetryButton() {
        if let delegate = delegate {
            delegate.retryAction()
        }
    }
    
    func configureActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.autoCenterInSuperview()
        activityIndicator.color = .blue
        activityIndicator.autoSetDimensions(to: CGSize(width: activityIndicatorHeight, height: activityIndicatorHeight))
        activityIndicator.isHidden = true
    }
    
    public func configure(state: EmptyViewState) {
        switch state {
        case .Loading:
            configureLoadingState()
        case .InitialSearch:
            configureInitialSearchstate()
        case .EmptySearch:
            configureEmptySearchState()
        case .Error:
            configureErrorstate()
        }
    }
    
    func configureLoadingState() {
        titleLabel.isHidden = true
        messageLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func configureInitialSearchstate() {
        titleLabel.isHidden = false
        messageLabel.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        titleLabel.text = "Looking for something?"
        messageLabel.text = "Search our database to find the perfect movie"
    }
    
    func configureErrorstate() {
        titleLabel.isHidden = false
        messageLabel.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        titleLabel.text = "Something went wrong"
        messageLabel.text = "Please try again"
    }
    
    func configureEmptySearchState() {
        titleLabel.isHidden = false
        messageLabel.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        titleLabel.text = "No search results"
        messageLabel.text = "We couldn't find a movie with that title"
    }
}
