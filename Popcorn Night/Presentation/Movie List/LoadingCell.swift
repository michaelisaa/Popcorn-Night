//
//  LoadingCell.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 18/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import UIKit
import PureLayout

class LoadingCell: UITableViewCell {
    let activityIndicator = UIActivityIndicatorView(forAutoLayout: ())
    let activityIndicatorHeight:CGFloat = 40
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    func configureView() {
        contentView.addSubview(activityIndicator)
        activityIndicator.autoSetDimensions(to: CGSize(width: activityIndicatorHeight, height: activityIndicatorHeight))
        activityIndicator.autoAlignAxis(toSuperviewAxis: .vertical)
        activityIndicator.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        activityIndicator.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
    }
}
