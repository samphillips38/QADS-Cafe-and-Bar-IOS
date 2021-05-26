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
    
    var chosenItem = Item()
    var allergenList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set the allergen list and reload data
        currentUser.getAllergenList(completion: { result in
            self.allergenList = result
            self.tableView.reloadData()
        })
        
    }
    

    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? AllergiesTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllergiesTableViewCell")
        }
        
//        cell.allergiesLabel.text = allergenList?[indexPath.row]
        print(allergenList)
        cell.allergiesLabel.text = "something"
        return cell
    }

}
