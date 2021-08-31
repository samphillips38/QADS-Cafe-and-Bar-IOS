//
//  AllergyPickerViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 17/05/2021.
//

import UIKit

private let reuseIdentifier = "AllergyTVC"
private let customAllergyReuseIdentifier = "CustomAllergyTVC"

class AllergyPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let rowHeight = CGFloat(50)
    var currentOrderItem = orderItem()
    var onDismiss = {}
    var otherAllergyText = ""
    
    func setUp() {
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
    }

    override func viewWillDisappear(_ animated: Bool) {
        if otherAllergyText != "" {
            let allergy = orderItem.allergy(name: otherAllergyText, isChosen: true)
            currentOrderItem.allergies.append(allergy)
        }
        onDismiss()
    }

    //MARK:- Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOrderItem.allergies.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < currentOrderItem.allergies.count { // Normal allegy
            // Configure the cell...
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? OptionTableViewCell else {
                fatalError("The dequeued cell is not an instance of OptionTableViewCell")
            }
            cell.cellType = constants.allergyCell
            cell.currentOrderItem = currentOrderItem
            cell.index = indexPath
            cell.makeCell()
            return cell
        } else { // Other Allergy
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: customAllergyReuseIdentifier, for: indexPath) as? CustomAllergyTableViewCell else {
                fatalError("The dequeued cell is not an instance of CustomTableViewCell")
            }
            cell.customAllergyTextField.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < currentOrderItem.allergies.count {
            // Set allergy
            currentOrderItem.allergies[indexPath.row].isChosen.toggle()
            
            //Reload cell
            tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK:- Text Field
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let newPos = rowHeight * CGFloat(currentOrderItem.allergies.count) * 2 / 3
        tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: newPos), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        otherAllergyText = textField.text ?? ""
        textField.resignFirstResponder()
    }
    
    //MARK:- Button Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
}
