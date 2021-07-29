//
//  OptionPickerViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 17/05/2021.
//

import UIKit

private let reuseIdentifier = "AllergyTVC"

class OptionPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var currentOrderItem = orderItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //Get allergen data
        currentUser.getAllergenList {
            self.tableView.reloadData()
        }
    }


    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.allergies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? AllergiesTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllergiesTableViewCell")
        }
        //Fill in Data
        let allergy = currentUser.allergies[indexPath.row]
        cell.allergiesLabel.text = allergy.name
//        if currentOrderItem.chosenAllergies.contains(allergy.name) {
//            cell.checkBox.isHidden = false
//        } else {
//            cell.checkBox.isHidden = true
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Add allergy
//        let allergy = currentOrderItem.allergies[indexPath.row]
//        if currentOrderItem.chosenAllergies.contains(allergy) {
//            currentOrderItem.chosenAllergies = currentOrderItem.chosenAllergies.filter { $0 != allergy }
//        } else {
//            currentOrderItem.chosenAllergies.append(allergy)
//        }
//        
//        //Reload cell
//        tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
//        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    //MARK:- Button Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            //Do something
        }
    }
}
