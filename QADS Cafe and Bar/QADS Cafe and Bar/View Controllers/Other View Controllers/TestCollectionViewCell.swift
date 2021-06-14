//
//  TestCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/06/2021.
//

import UIKit

private let reuseIdentifier = "TestTVC"

class TestCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    func setUp() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set by Item as the number of options is not varied by preferences
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
//        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) else {
//            fatalError("The dequeued cell is not an instance of OptionsTableViewCell")
//        }
//
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier!, for: indexPath)
        
        return cell
    }
    
    
}
