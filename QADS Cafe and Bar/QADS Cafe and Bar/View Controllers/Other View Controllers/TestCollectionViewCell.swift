//
//  TestCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/06/2021.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var collectionViewRow = 3
    var cellDic: [String: Any] = [:]
    var numRows = 4
    let rowHeight = CGFloat(50)
    
    func setUp() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = self.rowHeight

    }
    
    
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set by Item as the number of options is not varied by preferences
        return self.numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TestTVC", for: indexPath) as? TestTableViewCell else {
            fatalError("The dequeued cell is not an instance of TestTableViewCell")
        }
        
        cell.nameLabel.text = "ColRow: " +
                            String(collectionViewRow) +
                            ", TabRow: " +
                            String(indexPath.row)
        
        return cell
    }
    
    
}
