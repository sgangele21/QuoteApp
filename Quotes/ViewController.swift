//
//  ViewController.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/11/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import Firebase

// TODO: Put this in a struct along with other database values
let kDataBaseReference = "Quotes"

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackGroundColor")!)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let quoteGeneratorView = mainStoryBoard.instantiateViewController(withIdentifier: "QuoteGenerator") as! QuoteGeneratorViewController
        let savedQuotesView = mainStoryBoard.instantiateViewController(withIdentifier: "SavedQuotes") as! SavedQuotesViewController
        self.setupView(viewControllers: [quoteGeneratorView,savedQuotesView])
    }
    
    private func setupView(viewControllers : [UIViewController]) {
        for vc in viewControllers {
            // This is needed to create a parent - child
            // relationship between the views
            self.addChildViewController(vc)
            self.backgroundScrollView.addSubview(vc.view)
            // For implementing my own container view, so view needs to be aware of this
            vc.didMove(toParentViewController: self)
            if let savedQuotesView = vc as? SavedQuotesViewController {
                var savedQuotesFrame: CGRect = savedQuotesView.view.frame
                savedQuotesFrame.origin.x = self.view.frame.width
                savedQuotesView.view.frame = savedQuotesFrame
            }
        }
        let numberOfViews = CGFloat(viewControllers.count)
        self.backgroundScrollView.contentSize = CGSize(width: self.view.frame.width * numberOfViews, height: self.view.frame.height)
    }
    
}

