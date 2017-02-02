//
//  SavedQuotesViewController.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/13/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import Firebase

let kDarkRedColor = UIColor(colorLiteralRed: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
let kLightRedColor = UIColor(colorLiteralRed: 254.0/255.0, green: 135.0/255.0, blue: 122.0/255.0, alpha: 1.0)

class SavedQuotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let databaseReference = FIRDatabase.database().reference().child(kDataBaseReference)
    var quotes : [Quote] = []  {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialView()
        self.observeQuoteAddition()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTableViewConstraints()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuoteGeneratorViewController
        let index = self.tableView.indexPathForSelectedRow!.section
        destinationVC.backGroundColor = UIColor.clear
        destinationVC.quote = self.quotes[index]
        destinationVC.showSingleQuoteOnly = true
        destinationVC.gradientBackground = (kDarkRedColor,kLightRedColor)
    }
    
    private func observeQuoteAddition() {
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
    
    private func setupInitialView() {
        // Creates dynamically sized cell heights
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 175
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    private func updateTableViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10.0).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10.0).isActive = true
    }

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
