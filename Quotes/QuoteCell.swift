//
//  QuoteCell.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/20/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit

public class QuoteCell: UITableViewCell {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var authorLabel: UILabel!
    
    var quote: Quote!
    var viewController: UIViewController!
    
    public func setupCell(quoteText: String, authorText: String, quote: Quote, viewController: UIViewController) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
        self.quoteLabel.text = quoteText
        self.authorLabel.text = authorText
        self.quote = quote
        self.viewController = viewController
    }
    
    @IBAction func shareQuoteButton(_ sender: Any) {
        self.viewController.shareText(textToShare: quote.getStyledCompleteQuote(quoteStyle: .QuoteHyphen))
    }
}


