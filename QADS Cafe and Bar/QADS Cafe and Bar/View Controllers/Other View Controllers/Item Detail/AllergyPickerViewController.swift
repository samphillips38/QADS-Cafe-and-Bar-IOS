//
//  AllergyPickerViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 17/05/2021.
//

import UIKit

private let reuseIdentifier = "AllergyTVC"

class AllergyPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let rowHeight = CGFloat(50)
    var currentOrderItem = orderItem()
    var onDismiss = {}
    
    func setUp() {
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
    }

    override func viewWillDisappear(_ animated: Bool) {
        onDismiss()
    }

    //MARK:- Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOrderItem.allergies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? OptionTableViewCell else {
            fatalError("The dequeued cell is not an instance of TestTableViewCell")
        }
        cell.cellType = constants.allergyCell
        cell.currentOrderItem = currentOrderItem
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
    
    //MARK:- Button Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
}
