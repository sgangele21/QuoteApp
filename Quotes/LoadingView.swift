//
//  LoadingView.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/13/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    let animationDuration = 0.25
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configLoadingScreen(show: Bool) {
        UIView.animate(withDuration: self.animationDuration, animations: {() in
            show ?  self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            let labelAlpha : CGFloat = show ? 1.0 : 0.0
            self.loadingLabel.alpha = labelAlpha
            self.isHidden = !show
        })
    }
    
}
