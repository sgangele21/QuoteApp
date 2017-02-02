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
import FaveButton
import Spring

let kCornerRadius: CGFloat = 10.0
let kAnimationDuration = 0.25

class QuoteGeneratorViewController: UIViewController, AVSpeechSynthesizerDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet var tapForNewQuoteGesture: UITapGestureRecognizer!
    @IBOutlet weak var showAuthorsPageButton: FaveButton!
    @IBOutlet weak var likeQuoteButton: FaveButton!
    @IBOutlet weak var speakQuoteButton: FaveButton!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var quoteView: SpringView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var quote: Quote?
    var quoteClient: QuoteClient? = QuoteClient()
    // TODO: Make this lazy loading
    lazy var loadingView: LoadingView? = {
        if let loadingView = Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil)?[0] as? LoadingView {
            self.view.addSubview(loadingView)
            return loadingView
        }
        return nil
    }()
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance = AVSpeechUtterance()
    
    var backGroundColor = UIColor.clear
    var gradientBackground: (UIColor,UIColor)?
    
    var showSingleQuoteOnly: Bool = false
    var backButtonForSingleQuote: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "CloseButton"), for: .normal)
        return button
    }()
   
    lazy var safariVC: SFSafariViewController? = {
        if let quote = self.quote {
            let vc = SFSafariViewController(url: self.createGoogleURL(search: quote.getAuthor()))
            vc.modalPresentationCapturesStatusBarAppearance = true
            vc.delegate = self
            return vc
        }
        return nil
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.initialViewSetup()
            if self.showSingleQuoteOnly {
                try self.configForSingleQuoteOnly()
            }
        } catch QuoteError.LoadingViewError {
            self.showAlertViewController(title: "Issue with loading view", message: nil)
        } catch QuoteError.GradientViewError {
            self.showAlertViewController(title: "Issue with gradient view", message: nil)
        } catch {
            print("Some error")
        }
        if let quoteClient = self.quoteClient {
            quoteClient.fetchQuote(numberOfQuotes: 1) { quotes in
                let quote = quotes[0]
                self.quote = quote
                self.presentNewQuote(quote: quote)
            }
        }
    }
    
    // The underscore means when calling this method, you
    // Don't need to specify the parameter
    @IBAction func saveQuoteTapped(_ sender: Any) {
        if self.quote != nil {
            self.quote!.like = !self.quote!.like
        }else {
            self.showAlertViewController(title: "Issue liking quote", message: nil)
        }
    }
    
    @IBAction func openAuthorsPageTouchUp(_ sender: UIButton) {
        if let safariVC = self.safariVC {
            safariVC.modalPresentationStyle = .overFullScreen
            self.present(safariVC, animated: true
                , completion: nil)
        }
    }
    
    @IBAction func openAuthorsPageTouchDragOutside(_ sender: UIButton) {
        self.configButtonDisplay(button: self.showAuthorsPageButton, isSelected: false, isEnabled: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.showAuthorsPageButton.isSelected = false
        self.configButtonDisplay(button: self.showAuthorsPageButton, isSelected: false, isEnabled: nil)
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
            self.configButtonDisplay(button: self.speakQuoteButton, isSelected: nil, isEnabled: false)
        }else {
            self.showAlertViewController(title: "Issue speaking text", message: nil)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.configButtonDisplay(button: self.speakQuoteButton, isSelected: false, isEnabled: true)
    }
    
    @IBAction func generateQuoteTapped(_ sender: UITapGestureRecognizer) {
        self.configQuotePresentation(showQuote: false)
        if let quoteClient = self.quoteClient {
            quoteClient.fetchQuote(numberOfQuotes: 1) { quotes in
                let quote = quotes[0]
                self.quote = quote
                self.presentNewQuote(quote: quote)
            }
        }else {
            self.showAlertViewController(title: "Issue getting new quote", message: nil)
        }
    }
    
    @IBAction func shareQuotePressed(_ sender: Any) {
        if let quote = self.quote {
            self.shareText(textToShare: quote.getStyledCompleteQuote(quoteStyle: .QuoteHyphen))
        }else {
            self.showAlertViewController(title: "Issue sharing quote", message: nil)
        }
    }
    
    // TODO: Make this a smart method, because only like is being updated
    private func updateLikeButton(quote: Quote) {
        let likeStatus = quote.getLikeStatus()
        self.configButtonDisplay(button: self.likeQuoteButton, isSelected: likeStatus, isEnabled: nil)
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
        if showQuote == false {
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3.0, options: [], animations: {() in
                let y = 0 - self.view.frame.height
                // Creates slide up to top of screen animtion
                let up = CGAffineTransform(translationX: 0.0, y: y)
                self.quoteView.transform = up
            },completion: nil)

        }else {
            self.quoteView.isHidden = false
            self.quoteView.animation = "slideUp"
            self.quoteView.duration = 1.0
            self.quoteView.damping = 2.0
            self.quoteView.animate()
        }
        self.loadingView?.configLoadingScreen(show: !showQuote)
    }
    
    private func configButtonDisplay(button: FaveButton, isSelected: Bool?, isEnabled: Bool?) {
        if let selectionChange = isSelected {
            button.isSelected = selectionChange
        }
        if let enableChange = isEnabled {
            button.isEnabled = enableChange
        }
        
    }
    
    private func initialViewSetup() throws {
        speechSynthesizer.delegate = self
        self.quoteView.layer.masksToBounds = true
        self.quoteView.layer.cornerRadius = kCornerRadius
        self.quoteView.backgroundColor = UIColor.white
        self.view.backgroundColor = self.backGroundColor
        self.quoteView.isHidden = true
        if let loadingView = self.loadingView {
            loadingView.configLoadingScreen(show: true)
        }else {
            throw QuoteError.LoadingViewError
        }
    }
    
    private func presentNewQuote(quote: Quote) {
        self.configQuotePresentation(showQuote: true)
        self.updateLabels(quoteString: quote.getQuote(), authorString: quote.getAuthor())
        self.updateLikeButton(quote: quote)
    }
    
    private func configForSingleQuoteOnly() throws {
        self.quoteClient = nil
        self.tapForNewQuoteGesture.isEnabled = false
        self.moreButton.isHidden = true
        guard let gradientColors = self.gradientBackground else { throw QuoteError.GradientViewError }
        self.view.addGradientView(topColor: gradientColors.0, bottomColor: gradientColors.1)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeToDismiss))
        self.view.addGestureRecognizer(panGesture)
        
        self.presentNewQuote(quote: self.quote!)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        self.backButtonForSingleQuote.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func swipeToDismiss(panGesture: UIPanGestureRecognizer) {
        print(panGesture.velocity(in: self.view))
        self.view.frame.origin.y = panGesture.translation(in: self.view).y
        
        switch panGesture.state {
        case .ended:
            print("Ended")
            if Float(panGesture.velocity(in: self.view).y) > 200.0 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: kAnimationDuration, animations: {() in
                    self.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
                })
            }
        default: break
            
        }
    }
    
    // You have to add @objc for objective-c to be aware of the selector method
    @objc private func backButtonPressed(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}


enum QuoteError: Error {
    case LoadingViewError
    case GradientViewError
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
