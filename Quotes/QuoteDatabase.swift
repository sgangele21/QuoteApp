//
//  QuoteDatabase.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/12/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import Firebase

//let kDataBaseReference = "Quotes"

public class QuoteDatabase {
    
    public static var databaseRef = FIRDatabase.database().reference().child(kDataBaseReference)
    
    // Can only store objects of type NSNumber, NSString, NSDictionary, and NSArray.
    public static func postQuoteToDatabase(author: String, quote: String) {
        let post : [String : AnyObject] = ["author" : author as AnyObject, "quote" : quote as AnyObject]
        let newRef = databaseRef.childByAutoId()
        newRef.setValue(post)
    }
    
    public static func observeDatabase() {
        databaseRef.observe(.childAdded, with: { dataSnapshot in
            print("\n\n\(dataSnapshot.value)")
            if let quoteDict = dataSnapshot.value, let quote = quoteDict as? [String : [String : String]]  {
                for value in quote.values {
                    
                }
            }
        })
    }
}
