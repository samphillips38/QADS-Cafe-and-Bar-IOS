//
//  BasketViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 15/01/2021.
//

import UIKit

private let reuseIdentifier = "OrderItemTVC"

class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, orderItemsDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        
        setPrice()
    }
    
    func setPrice() {
        totalLabel.text = "£" + String(format: "%.2f", currentUser.currentOrder.price)
    }
    
    
    //MARK: -Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.currentOrder.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? OrderItemsTableViewCell else {
            fatalError("The dequeued cell is not an instance of OrderItemsTableViewCell")
        }
        
        cell.fillInData(item: currentUser.currentOrder.items[indexPath.row])
        
        //set delegate and index
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do something
        tableView.reloadRows(at: [indexPath], with: .fade)
        
    }
    
    func deleteItemTapped(index: Int) {
        
        //Show warning message about deleting the item
        let message = "Are you sure you want to delete this item?"
        
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            
            //delete item
            currentUser.currentOrder.removeItemAt(index: index)
            self.setPrice()
            self.tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: -Button actions

    @IBAction func checkoutTapped(_ sender: Any) {
        
        currentUser.currentOrder.email = "samphillips38@gmail.com"
        
        currentUser.currentOrder.saveOrder {
            //do something
        }
        
    }
}
