//
//  ViewController.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/11/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var generateQuoteButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var quoteClient = QuoteClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // The underscore means when calling this method, you 
    // Don't need to specify the parameter
    @IBAction func quoteButtonPressed(_ sender: Any) {
        self.quoteClient.fetchQuote(numberOfQuotes: 1) { quotes in
            let quote = quotes[0]
            self.updateLabels(quoteString: quote.getQuote(), authorString: quote.getAuthor())
            
        }
    }
    
    private func updateLabels(quoteString : String?, authorString: String?) {
        if let quote = quoteString {
            self.quoteLabel.text = quote
        }
        if let author = authorString {
            self.authorLabel.text = author
        }
    }
    
    
}

