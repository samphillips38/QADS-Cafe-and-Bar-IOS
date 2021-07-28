//
//  TestCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/06/2021.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, TestOptionsCellDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let rowHeight = CGFloat(50)
    var cellType = constants.optionCell
    
    var currentOrderItem = orderItem()
    
    func setUp() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = self.rowHeight
    }
    
    func onStepperClick(index: Int, sender: UIStepper) {
        
        //update the quantity based on stepper value
        currentOrderItem.options[index].quantity = Int(sender.value)
        
        //Update price
        currentOrderItem.updatePrice()
//        setPrice(price: currentOrderItem.price)
    }
    
    
    
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set by Item as the number of options is not varied by preferences
        return currentOrderItem.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = currentOrderItem.options[indexPath.row]
        if !option.canHaveMultiple {
            
            // Configure the cell...
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TestTVC", for: indexPath) as? TestTableViewCell else {
                fatalError("The dequeued cell is not an instance of TestTableViewCell")
            }
            
            cell.thisOrderItem = currentOrderItem
            cell.index = indexPath
            cell.makeCell()
            return cell
            
        } else {
            
            // Configure the cell...
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "MultipleTestTVC", for: indexPath) as? TestTableViewCell else {
                fatalError("The dequeued cell is not an instance of TestTableViewCell")
            }
            
            cell.thisOrderItem = currentOrderItem
            cell.index = indexPath
            cell.makeCell()
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If can have multiple then skip
        let option = currentOrderItem.options[indexPath.row]
        if option.canHaveMultiple {
            tableView.reloadRows(at: [indexPath], with: .fade)
            return
        }
        // Set quantity
        let refreshedIndexes = switchSelectedTo(index: indexPath)
        
        //Reload cell
        tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
        tableView.reloadRows(at: refreshedIndexes, with: .fade)
    }
    
    func switchSelectedTo(index: IndexPath) -> [IndexPath] {
        var optionList = currentOrderItem.options
        if optionList[index.row].quantity > 0 {
            optionList[index.row].quantity = 0
            return [index]
        }
        var switchedIndexes: [IndexPath] = []
        for i in 0...(optionList.count - 1) {
            if optionList[i].quantity != 0 {
                switchedIndexes.append(IndexPath(row: i, section: 0))
                optionList[i].quantity = 0
            }
        }
        optionList[index.row].quantity = 1
        switchedIndexes.append(index)
        currentOrderItem.options = optionList
        return switchedIndexes
    }
}
