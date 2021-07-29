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
    var index: IndexPath?
    
    var currentOrderItem = orderItem()
    private var typeIndex = -1 // Which type are we on
    
    func setUp() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = self.rowHeight
        
        if cellType == constants.optionCell {
            titleLabel.text = "This is an option"
        } else if cellType == constants.typeCell {
            typeIndex = (index?.row ?? 0) - 2 // Minus one for title and one for options
            let type = currentOrderItem.types[typeIndex]
            titleLabel.text = type.name
        }
    }
    
    func onStepperClick(index: Int, sender: UIStepper) {
        
        //update the quantity based on stepper value
        currentOrderItem.options[index].quantity = Int(sender.value)
        
        //Update price
        currentOrderItem.updatePrice()
    }
    
    func getOptionList() -> [orderItem.Option]{
        if cellType == constants.optionCell {
            return currentOrderItem.options
        } else {
            let type = currentOrderItem.types[typeIndex]
            return type.choices
        }
    }
    
    
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set by Item as the number of options is not varied by preferences
        return getOptionList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = getOptionList()[indexPath.row]
        if !option.canHaveMultiple {
            
            // Configure the cell...
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TestTVC", for: indexPath) as? TestTableViewCell else {
                fatalError("The dequeued cell is not an instance of TestTableViewCell")
            }
            
            cell.thisOrderItem = currentOrderItem
            cell.index = indexPath
            cell.typeIndex = typeIndex
            cell.cellType = cellType
            cell.makeCell()
            return cell
            
        } else {
            
            // Configure the cell...
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "MultipleTestTVC", for: indexPath) as? TestTableViewCell else {
                fatalError("The dequeued cell is not an instance of TestTableViewCell")
            }
            
            cell.thisOrderItem = currentOrderItem
            cell.index = indexPath
            cell.typeIndex = typeIndex
            cell.cellType = cellType
            cell.makeCell()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If can have multiple then skip
        let option = getOptionList()[indexPath.row]
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
        var optionList = getOptionList()
        var switchedIndexes: [IndexPath] = []
        
        if optionList[index.row].quantity > 0 { // Deselect if already selected
            optionList[index.row].quantity = 0
            switchedIndexes = [index]
            
        } else { // Not yet selected
            for i in 0...(optionList.count - 1) { // Deselect all other cells
                if optionList[i].quantity != 0 {
                    switchedIndexes.append(IndexPath(row: i, section: 0))
                    optionList[i].quantity = 0
                }
            }
            optionList[index.row].quantity = 1
            switchedIndexes.append(index)
        }
        
        // Save to currentOrder object
        if cellType == constants.optionCell {
            currentOrderItem.options = optionList
        } else if cellType == constants.typeCell {
            currentOrderItem.types[typeIndex].choices = optionList
        }
        
        return switchedIndexes
    }
}
