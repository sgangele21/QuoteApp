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
