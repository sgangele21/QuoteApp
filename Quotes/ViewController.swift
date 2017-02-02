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
let kDarkBlueColor = UIColor(colorLiteralRed: 0.0, green: 126.0/255.0, blue: 1.0, alpha: 1.0)
let kLightBlueColor = UIColor(colorLiteralRed: 136.0/255.0, green: 203.0/255.0, blue: 1.0, alpha: 1.0)

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGradientView(topColor: kDarkBlueColor, bottomColor: kLightBlueColor)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let quoteGeneratorView = mainStoryBoard.instantiateViewController(withIdentifier: "QuoteGenerator") as! QuoteGeneratorViewController
        let savedQuotesView = mainStoryBoard.instantiateViewController(withIdentifier: "SavedQuotes") as! SavedQuotesViewController
        self.addViewsOnScrollView(viewControllers: [quoteGeneratorView,savedQuotesView])
    }
    
    private func addViewsOnScrollView(viewControllers : [UIViewController]) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundScrollView.layoutIfNeeded()
    }
    
}


extension UIView {
    func addGradientView(topColor: UIColor, bottomColor: UIColor = UIColor.white) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
