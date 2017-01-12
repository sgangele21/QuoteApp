//
//  QuoteClient.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/11/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

/*
 http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1
 */

import Alamofire

public class QuoteClient {
    
    // This is created to disable caching
    // So, we need a varaible that doesn't get deallocated with
    // Each fetch of a quote
    var manager = SessionManager()
    
    //If a closure is passed as an argument to a function and it is invoked after the function returns 
    //the closure is @escaping.
    public func fetchQuote(numberOfQuotes : Int, completionHandler : @escaping (([Quote]) -> Void)) {
        let parameters: Parameters = [QuoteRequest.Keys.filter + QuoteRequest.Keys.orderBy : QuoteRequest.Values.random, QuoteRequest.Keys.filter + QuoteRequest.Keys.postsPerPage : "\(numberOfQuotes)"]
        
        // Disable caching
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.manager = Alamofire.SessionManager(configuration: config)
        self.manager.request(QuoteRequest.baseURL, parameters: parameters).responseJSON { response in
            switch(response.result) {
            case .failure(let error):
                print("Error, failed to generate quote")
                dump(error)
                // TODO: Throw an error here
            case .success:
                guard let JSON = response.result.value as? [[String : AnyObject]] else {return}
                let quotes = JSON.flatMap { quote in
                    return Quote(JSON: quote)
                }
                completionHandler(quotes)

            }
        }
    }

}

struct QuoteRequest {
    
    static let baseURL = "https://quotesondesign.com/wp-json/posts"
    let numOfQuotes : Int
    
    init(numOfQuotes : Int) {
        self.numOfQuotes = numOfQuotes
    }
    
    struct Keys {
        static let filter = "filter"
        static let orderBy = "[orderby]"
        static let postsPerPage = "[posts_per_page]"
    }
    struct Values {
        static let random = "rand"
    }
    
}

struct QuoteParse {
    static let title = "title"
    static let id = "ID"
    static let content = "content"
    static let link = "link"
}

// TODO: Check for forced unwrapping
public class Quote {
    private let author: String
    private let quote: String
    private let id: Int
    private let link: URL
    
    init?(JSON: [String: AnyObject]) {
        guard let title = JSON[QuoteParse.title] as? String else {return nil}
        guard let content  = JSON[QuoteParse.content] as? String else {return nil}
        guard let id = JSON[QuoteParse.id] as? Int else {return nil}
        guard let urlString = JSON[QuoteParse.link] as? String, let link = URL(string: urlString) else {return nil}
        
        self.author = title
        self.quote = content
        self.id = id
        self.link = link
    }
    
    func styleQuote() -> NSAttributedString {
        if let quote = self.decodeString(encodedString: self.quote), let author = self.decodeString(encodedString: self.author) {
            let italicContentAttribute = [NSFontAttributeName : UIFont.italicSystemFont(ofSize: 15)]
            var italicContent = NSMutableAttributedString(string: quote, attributes: italicContentAttribute)
            
            let boldTitleAttribute = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
            let boldTitle = NSMutableAttributedString(string: author, attributes: boldTitleAttribute)
            
            italicContent.append(NSAttributedString(string: "\n"))
            italicContent.append(boldTitle)

            return italicContent
        }else {
            return NSAttributedString(string: "Nothing")
        }
    }
    
    func getAuthor() -> String {
        guard let title = self.decodeString(encodedString: self.author) else {return ""}
        return title;
    }
    
    func getQuote() -> String {
        guard let quote = self.decodeString(encodedString: self.quote) else {return ""}
        return quote;
    }
    
    private func decodeString(encodedString : String) -> String? {
        let encodedData = encodedString.data(using: String.Encoding.utf8)!
        do {
            return try NSAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
        }catch(let error) {
            print(error)
            return nil
        }
    }
}
