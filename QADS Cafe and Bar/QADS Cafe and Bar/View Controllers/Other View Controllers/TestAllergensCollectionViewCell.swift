//
//  TestAllergensCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 17/06/2021.
//

import UIKit

class TestAllergensCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chosenAllergiesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let rowHeight = CGFloat(50)
    var currentOrderItem = orderItem()
//    var allergyList: [orderItem.allergy] = []
    
    func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
    }
    
    
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set by Item as the number of options is not varied by preferences
        return currentOrderItem.allergies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "optionTVC", for: indexPath) as? TestTableViewCell else {
            fatalError("The dequeued cell is not an instance of TestTableViewCell")
        }
        cell.cellType = constants.allergyCell
        cell.thisOrderItem = currentOrderItem
        cell.index = indexPath
        cell.makeCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set allergy
        currentOrderItem.allergies[indexPath.row].isChosen.toggle()
        
        //Reload cell
        tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
}