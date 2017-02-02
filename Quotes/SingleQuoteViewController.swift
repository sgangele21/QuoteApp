//
//  SingleQuoteViewController.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/24/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import Spring
import LTMorphingLabel

public class SingleQuoteViewController: UIViewController {
    
    @IBOutlet weak var authorLabel: LTMorphingLabel!
    @IBOutlet weak var quoteLabel: LTMorphingLabel!
    @IBOutlet weak var singleQuoteView: SpringView!
    
    var quote: Quote!
    
    @IBOutlet weak var speakTextButton: UIButton!
    @IBOutlet weak var showAuthorsPageButton: UIButton!
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.singleQuoteView.layer.masksToBounds = true
        self.singleQuoteView.layer.cornerRadius = kCornerRadius
        self.updateLabels(quoteString: self.quote.getQuote(), authorString: self.quote.getAuthor())
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
