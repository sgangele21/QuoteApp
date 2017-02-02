//
//  Quote.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/13/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import Firebase

public struct Quote {
    
    private let databaseReference = FIRDatabase.database().reference().child(kDataBaseReference)
    private let author: String
    private let quote: String
    private let id: Int
    private let link: URL
    public var like = false
    private var ref : FIRDatabaseReference?
    
    init?(JSON: [String: AnyObject]) {
        guard let title = JSON[QuoteParse.title] as? String else { return nil }
        guard let content  = JSON[QuoteParse.content] as? String else { return nil }
        guard let id = JSON[QuoteParse.id] as? Int else {return nil}
        guard let urlString = JSON[QuoteParse.link] as? String, let link = URL(string: urlString) else { return nil }
        
        self.author = title
        self.quote = content
        self.id = id
        self.link = link
    }
    
    init?(snapshot : FIRDataSnapshot) {
        guard let snapshotValues = snapshot.value as? [String : AnyObject] else { return nil }
        self.init(JSON:snapshotValues)
        self.ref = snapshot.ref
    }
    
    func getAuthor() -> String {
        guard let title = self.decodeString(encodedString: self.author) else { return "" }
        return title.trimmingCharacters(in: .whitespacesAndNewlines);
    }
    
    func getQuote() -> String {
        guard let quote = self.decodeString(encodedString: self.quote) else { return "" }
        return quote.trimmingCharacters(in: .whitespacesAndNewlines);
    }
    
    func getStyledCompleteQuote(quoteStyle: QuoteStyle) -> String {
        var fullQuote = "\(self.getQuote())"
        switch quoteStyle {
        case .QuoteHyphen:
            fullQuote += "\n-\n\(self.getAuthor())"
        case .QuoteBy:
            fullQuote += "\n-By \(self.getAuthor())"
        case .QuoteComma:
            fullQuote += ",\(self.getAuthor())"
        case .QuoteNewLine:
            fullQuote += "\n\(self.getAuthor())"
        }
        return fullQuote
    }
    
    func getLink() -> String {
        guard let link = self.decodeString(encodedString: self.link.absoluteString) else {return ""}
        return link
    }
    
    func getLikeStatus() -> Bool {
        return self.like
    }
    
    // Like starts out false, so this logic would then make sense
    mutating func changeLikeStatus() {
        self.like = !self.like
        print("Like Quote: \(self.like)")
        self.like ? self.postQuote() : self.removeQuote()
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
    
    func toAnyObject() -> Any {
        return [QuoteParse.title : self.getAuthor(),
                QuoteParse.content : self.getQuote(),
                QuoteParse.link : self.getLink(),
                QuoteParse.id : self.id]
    }
    
    mutating func postQuote() {
        self.ref = databaseReference.childByAutoId()
        self.ref?.setValue(self.toAnyObject())
    }
    
    func removeQuote() {
        guard let quoteReference = self.ref else {return}
        quoteReference.removeValue()
    }
    

}

enum QuoteStyle {
    case QuoteBy
    case QuoteHyphen
    case QuoteComma
    case QuoteNewLine
}
