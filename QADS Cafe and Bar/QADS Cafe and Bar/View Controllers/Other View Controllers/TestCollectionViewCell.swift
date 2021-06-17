//
//  TestCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/06/2021.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let rowHeight = CGFloat(50)
    var cellType = "Option"
    
    var optionDic: [String: Any] = [:]
    var optionList: [String] = []
    
    var typeDic: [String: Any] = [:]
    var typeList: [String] = []
    
    func setUp() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = self.rowHeight

        for (key, _) in optionDic {
            optionList.append(key)
        }

    }
    
    
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set by Item as the number of options is not varied by preferences
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TestTVC", for: indexPath) as? TestTableViewCell else {
            fatalError("The dequeued cell is not an instance of TestTableViewCell")
        }
        
        cell.nameLabel.text = optionList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Set row to selected
        
        //Reload cell
        tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
}
