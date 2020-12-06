//
//  ItemDetailViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/12/2020.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var outOfStockLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToBasketButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //Options
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    var chosenItem = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillInData()
        layout()
        
        //stepper settings
        quantityStepper.maximumValue = 10
        quantityStepper.minimumValue = 1
    }
    
    
    func layout() {
        
        //Add to basket button
        addToBasketButton.layer.cornerRadius = 20
        addToBasketButton.layer.borderWidth = 1
        addToBasketButton.layer.borderColor = UIColor.blue.cgColor
        
        //Done button
        doneButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        doneButton.layer.cornerRadius = 5
        
    }
    
    
    func fillInData() {
        itemNameLabel.text = chosenItem.name
        descriptionLabel.text = chosenItem.desc
        
        if chosenItem.stock ?? false {
            outOfStockLabel.isHidden = true
            addToBasketButton.setTitle("Add to basket", for: .normal)
        } else {
            outOfStockLabel.isHidden = false
            outOfStockLabel.text = "This item is out of stock."
            addToBasketButton.setTitle("This item is out of stock", for: .normal)
        }
    }

    //MARK:- Button Actions
    
    @IBAction func addToBasketTapped(_ sender: Any) {
        
        if chosenItem.stock! {
            currentUser.basketItems?.append(chosenItem)
            
            self.dismiss(animated: true) {
                //do something on completion
            }
        }
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            //Do something
        }
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        quantityLabel.text = Int(sender.value).description
        chosenItem.options?["quantity"] = Int(sender.value).description
    }
}
