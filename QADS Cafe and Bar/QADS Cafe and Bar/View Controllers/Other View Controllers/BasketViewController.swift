//
//  BasketViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 15/01/2021.
//

import UIKit

private let reuseIdentifier = "OrderItemTVC"

class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, orderItemsDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var crsidLabel: UILabel!
    
    @IBOutlet weak var orderNotesTextField: UITextField!
    @IBOutlet weak var orderStackView: UIStackView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        
        //set action for stack view
        orderStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(orderTapped(_:))))
        orderStackView.isUserInteractionEnabled = true
        
        //Text view
        orderNotesTextField.delegate = self
        
        layout()
        setPrice()
    }
    
    func setPrice() {
        let price = currentUser.barOrder.price + currentUser.cafeOrder.price
        totalLabel.text = "£" + String(format: "%.2f", price)
    }
    
    func layout() {
        
        //fill in details
        nameLabel.text = currentUser.firstName! + " " + currentUser.lastName!
        emailLabel.text = currentUser.email
        crsidLabel.text = currentUser.crsid
        
        //Stack View Layout for button
        orderStackView.layer.cornerRadius = orderStackView.frame.height/2
    }
    
    //MARK: -Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.cafeOrder.items.count + currentUser.barOrder.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? OrderItemsTableViewCell else {
            fatalError("The dequeued cell is not an instance of OrderItemsTableViewCell")
        }
        
        cell.fillInData(item: currentUser.getItemAt(index: indexPath.row))
        
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
            currentUser.removeItemAt(index: index)
            self.setPrice()
            self.tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: -Text Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentUser.cafeOrder.note = textField.text
        currentUser.barOrder.note = textField.text
    }
    
    
    //MARK: -Button actions
    
    @objc func orderTapped(_ sender: UITapGestureRecognizer? = nil) {
        
        //Show warning message about Checking out
        let message = "Before you checkout, have you topped up your uPay?"
        
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            //Checkout order once confirmed
            currentUser.checkout {
                
                //Show confirmation screen (fullscreen)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let confirmationVC = storyBoard.instantiateViewController(withIdentifier: "OrderConfirmationVC") as! OrderConfirmationViewController
                confirmationVC.modalPresentationStyle = .fullScreen
                
                self.present(confirmationVC, animated: true) {
                    
                    //Refresh the table data
                    self.tableView.reloadData()
                    self.orderNotesTextField.text = ""
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            //Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
