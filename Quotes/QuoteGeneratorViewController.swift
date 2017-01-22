//
//  QuoteGeneratorViewController.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/13/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation

let kCornerRadius: CGFloat = 10.0
let kAnimationDuration = 0.25

class QuoteGeneratorViewController: UIViewController, AVSpeechSynthesizerDelegate, SFSafariViewControllerDelegate {
    
    
    @IBOutlet weak var showAuthorsPageButton: UIButton!
    @IBOutlet weak var likeQuoteButton: UIButton!
    @IBOutlet weak var speakQuoteButton: UIButton!
    @IBOutlet weak var quoteView: UIVisualEffectView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var quoteClient = QuoteClient()
    var loadingView = LoadingView()
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance = AVSpeechUtterance()
    var quote: Quote? {
        didSet {
            self.configQuotePresentation(showQuote: true)
        }
    }
    lazy var safariVC: SFSafariViewController? = {
        if let quote = self.quote {
            let vc = SFSafariViewController(url: self.createGoogleURL(search: quote.getAuthor()))
            vc.modalPresentationCapturesStatusBarAppearance = true
            vc.delegate = self
            return vc
        }
        return nil
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewSetup()
        if let loadingView = Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil)?[0] as? LoadingView {
            self.loadingView = loadingView
            self.view.addSubview(loadingView)
            self.configQuotePresentation(showQuote: false)
        }
        self.quoteClient.fetchQuote(numberOfQuotes: 1) { quotes in
            let quote = quotes[0]
            self.quote = quote
            self.updateLabels(quoteString: quote.getQuote(), authorString: quote.getAuthor())
        }
    }
    
    // The underscore means when calling this method, you
    // Don't need to specify the parameter
    @IBAction func saveQuoteTapped(_ sender: Any) {
        if self.quote != nil {
            self.quote!.changeLikeStatus()
            self.quote!.getLikeStatus() ?
                self.configButtonDisplay(button: self.likeQuoteButton, newButtonImage: #imageLiteral(resourceName: "ColoredLikeQuoteIcon")) :
                self.configButtonDisplay(button: self.likeQuoteButton, newButtonImage: #imageLiteral(resourceName: "LikeQuoteIcon"))
        }else {
            self.showAlertViewController(title: "Issue liking quote", message: nil)
        }
    }
    
    @IBAction func openAuthorsPageTouchDown(_ sender: UIButton) {
        self.configButtonDisplay(button: self.showAuthorsPageButton, newButtonImage: #imageLiteral(resourceName: "ColoredAuthorsWebPageIcon"))
    }
    
    @IBAction func openAuthorsPageTouchUp(_ sender: UIButton) {
        if let safariVC = self.safariVC {
            safariVC.modalPresentationStyle = .overFullScreen
            self.present(safariVC, animated: true
                , completion: nil)
        }
    }
    
    @IBAction func openAuthorsPageTouchDragOutside(_ sender: UIButton) {
        self.configButtonDisplay(button: self.showAuthorsPageButton, newButtonImage: #imageLiteral(resourceName: "AuthorsWebPageIcon"))
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.configButtonDisplay(button: self.showAuthorsPageButton, newButtonImage: #imageLiteral(resourceName: "AuthorsWebPageIcon"))
    }
    
    private func createGoogleURL(search: String) -> URL {
        let baseURL = "https://www.google.com/#safe=active&q="
        var url = search
        url = url.trimmingCharacters(in: .whitespacesAndNewlines)
        url = url.replacingOccurrences(of: " ", with: "+")
        url = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: baseURL + url)!
        
    }
    
    @IBAction func speakQuote(_ sender: Any) {
        // Assert: Don't speak text again once playing
        if self.speechSynthesizer.isSpeaking { return }
        
        if let quote = self.quote {
            self.speechUtterance = AVSpeechUtterance(string: quote.getStyledCompleteQuote(quoteStyle: .QuoteBy))
            self.speechSynthesizer.speak(self.speechUtterance)
            self.configButtonDisplay(button: self.speakQuoteButton, newButtonImage: #imageLiteral(resourceName: "ColoredSpeakTextIcon"))
            
        }else {
            self.showAlertViewController(title: "Issue speaking text", message: nil)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.configButtonDisplay(button: self.speakQuoteButton, newButtonImage: #imageLiteral(resourceName: "SpeakTextIcon"))
    }
    
    @IBAction func generateQuoteTapped(_ sender: UITapGestureRecognizer) {
        self.configQuotePresentation(showQuote: false)
        self.quoteClient.fetchQuote(numberOfQuotes: 1) { quotes in
            let quote = quotes[0]
            self.quote = quote
            self.updateLabels(quoteString: quote.getQuote(), authorString: quote.getAuthor())
            self.updateButtons()
        }
    }
    
    @IBAction func shareQuotePressed(_ sender: Any) {
        if let quote = self.quote {
            self.shareText(textToShare: quote.getStyledCompleteQuote(quoteStyle: .QuoteHyphen))
        }else {
            self.showAlertViewController(title: "Issue sharing quote", message: nil)
        }
    }
    
    // TODO: Make this a smart method
    private func updateButtons() {
        if self.quote != nil {
            self.quote!.getLikeStatus() ?
                self.configButtonDisplay(button: self.likeQuoteButton, newButtonImage: #imageLiteral(resourceName: "ColoredLikeQuoteIcon")) :
                self.configButtonDisplay(button: self.likeQuoteButton, newButtonImage: #imageLiteral(resourceName: "LikeQuoteIcon"))
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
    
    private func configQuotePresentation(showQuote: Bool) {
        self.loadingView.configLoadingScreen(show: !showQuote)
        showQuote ? self.authorLabel.fadeIn() : self.authorLabel.fadeOut()
        showQuote ? self.quoteLabel.fadeIn() : self.quoteLabel.fadeOut()
        showQuote ? self.quoteView.fadeIn() : self.quoteView.fadeOut()
    }
    
    private func configButtonDisplay(button: UIButton, newButtonImage: UIImage) {
        UIView.transition(with: button, duration: kAnimationDuration, options: .transitionCrossDissolve, animations: {() in
            button.setImage(newButtonImage, for: .normal)
        }, completion: nil)
    }
    
    private func initialViewSetup() {
        speechSynthesizer.delegate = self
        self.quoteView.layer.masksToBounds = true
        self.quoteView.layer.cornerRadius = kCornerRadius
        self.view.backgroundColor = UIColor.clear
    }

}

extension UIViewController {
    
    public func showAlertViewController(title : String?, message : String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true
            , completion: nil)
    }
    
    public func shareText(textToShare: String) {
        let activityItem = [textToShare]
        let sharingActivityVC = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        sharingActivityVC.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.openInIBooks, UIActivityType.postToVimeo, UIActivityType.saveToCameraRoll]
        // Remember  that sharing is different for iPhone and iPad
        sharingActivityVC.popoverPresentationController?.sourceView = self.view
        self.present(sharingActivityVC, animated: true, completion: nil)
    }
}
