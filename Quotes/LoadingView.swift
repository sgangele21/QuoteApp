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
        self.isUserInteractionEnabled = false
    }
    
    func configLoadingScreen(show: Bool) {
        UIView.animate(withDuration: self.animationDuration, animations: {() in
            let newAlpha : CGFloat = show ? 1.0 : 0.0
            self.loadingIndicator.alpha = newAlpha
            self.loadingLabel.alpha = newAlpha
            show ?  self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        })
        
    }
    
}
