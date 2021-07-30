//
//  TestCheckoutCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 29/07/2021.
//

import UIKit

class TestCheckoutCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToBasketButton: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderStackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var currentOrderItem = orderItem()
    var dismiss = {}
    var inStock = false
    
    func setUp() {
        
        //set action for stack view
        orderStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToBasketTapped(_:))))
        orderStackView.isUserInteractionEnabled = true
        
        // Layout
        quantityLabel.text = String(currentOrderItem.quantity)
        orderStackView.layer.cornerRadius = orderStackView.frame.height/2
        priceLabel.text = "£" + String(format: "%.2f", currentOrderItem.price)
        if inStock {
            errorLabel.isHidden = true
        } else {
            errorLabel.isHidden = false
        }
    }
    
    @objc func addToBasketTapped(_ sender: UITapGestureRecognizer? = nil) {
        if currentOrderItem.location == "Cafe" {
            currentUser.cafeOrder.addItem(item: currentOrderItem)
        } else {
            currentUser.barOrder.addItem(item: currentOrderItem)
        }
        // Dismiss screen
        dismiss()
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        currentOrderItem.quantity = Int(sender.value)
        currentOrderItem.updatePrice()
        setUp()
    }
}
