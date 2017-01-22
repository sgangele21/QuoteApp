//
//  SavedQuotesViewController.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/13/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import Firebase

class SavedQuotesViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let databaseReference = FIRDatabase.database().reference().child(kDataBaseReference)
    var quotes : [Quote] = []  {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Creates dynamically sized cell heights
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 175
        // In order to set a shadow, you have to set all 4 shadow properties
//        headerView.layer.shadowRadius = 5
//        headerView.layer.shadowOffset = CGSize(width: 1, height: 1)
//        headerView.layer.shadowColor = UIColor.black.cgColor
//        headerView.layer.shadowOpacity = 1.0
        databaseReference.observe(.value, with: { (snapshot) in
            var quotes : [Quote] = []
            for child in snapshot.children {
                let snapshotChild = child as! FIRDataSnapshot
                if let quote = Quote(snapshot: snapshotChild) {
                    quotes.append(quote)
                }
            }
            self.quotes = quotes
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension SavedQuotesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.quotes.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID")! as! QuoteCell
        let index = indexPath.section
        let quote = self.quotes[index]
        let quoteText = quote.getQuote()
        let authorText = quote.getAuthor()
        cell.setupCell(quoteText: quoteText, authorText: authorText, quote: quote, viewController: self)
        
        return cell
    }
    
}
