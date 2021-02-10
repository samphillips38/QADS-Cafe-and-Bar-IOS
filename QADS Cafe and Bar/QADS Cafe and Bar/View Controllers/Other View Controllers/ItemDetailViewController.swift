//
//  ItemDetailViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/12/2020.
//

import UIKit

private let reuseIdentifier = "OptionTVC"

class ItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, optionsCellDelegate {
    
    @IBOutlet weak var itemImage: CustomImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var outOfStockLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //Options
    @IBOutlet weak var optionTableView: UITableView!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addStackView: UIStackView!
    @IBOutlet weak var noCustomisationsLabel: UILabel!
    
    var chosenItem = Item()
    var currentOrderItem = orderItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //begin order
        currentOrderItem.createOrderItem(item: chosenItem)
        
        fillInData()
        layout()
        
        //Table View
        optionTableView.delegate = self
        optionTableView.dataSource = self
        
        //set action for stack view
        addStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToBasketTapped(_:))))
        addStackView.isUserInteractionEnabled = true
    }
    
    
    func layout() {
        
        //Done button
        doneButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        doneButton.layer.cornerRadius = 5
        
        //Stack View Layout
        addStackView.layer.cornerRadius = addStackView.frame.height/2
        
        //Table View height
        tableViewHeight.constant = CGFloat(((chosenItem.options ?? [:]).count * 41))
        
        
        if currentOrderItem.options.count ?? 0 == 0 {
            optionTableView.isHidden = true
            noCustomisationsLabel.isHidden = false
        }
    }
    
    
    func fillInData() {
        
        //All data that is not changed by the order preferences is loaded from the Item
        itemNameLabel.text = chosenItem.name
        descriptionLabel.text = chosenItem.desc
        
        if chosenItem.stock ?? false {
            outOfStockLabel.isHidden = true
        } else {
            outOfStockLabel.isHidden = false
            outOfStockLabel.text = "This item is out of stock."
        }
        
        //Load price from the order item as this could be changed by preferences
        setPrice(price: currentOrderItem.price)
        
        //Get the item image from firebase
        itemImage.LoadImageUsingCache(ImageRef: chosenItem.getImageRef()) { (isFound) in
            if !isFound {
                //Do something if the image could not be found
                print("not found")
            }
        }
        
    }
    
    func setPrice(price: Double) {
        priceLabel.text = "£" + String(format: "%.2f", price)
    }
    
    //MARK:- Options Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set by Item as the number of options is not varied by preferences
        return chosenItem.options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? OptionsTableViewCell else {
            fatalError("The dequeued cell is not an instance of OptionsTableViewCell")
        }
        
        //Input cell data
        let options = currentOrderItem.options
        cell.setOptions(options: options, index: indexPath.row)
        
        //Set the delegate and index path of cell
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if currentOrderItem.options[indexPath.row].canHaveMultiple {
            //Dont do anything (this will be controlled by stepper
        } else {
            
            //Toggle quantity for single value options
            let quantity = currentOrderItem.options[indexPath.row].quantity
            currentOrderItem.options[indexPath.row].quantity = (quantity + 1) % 2
            
            //Update Price
            currentOrderItem.updatePrice()
            setPrice(price: currentOrderItem.price)
            
            //Reload cell
            tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func onStepperClick(index: Int, sender: UIStepper) {
        
        //update the quantity based on stepper value
        currentOrderItem.options[index].quantity = Int(sender.value)
        
        //Update price
        currentOrderItem.updatePrice()
        setPrice(price: currentOrderItem.price)
    }
    

    //MARK:- Button Actions
    
    @objc func addToBasketTapped(_ sender: UITapGestureRecognizer? = nil) {
        if currentOrderItem.location == "Cafe" {
            currentUser.cafeOrder.addItem(item: currentOrderItem)
        } else {
            currentUser.barOrder.addItem(item: currentOrderItem)
        }
        dismiss(animated: true) {
            //Do somehting
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            //Do something
        }
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        
        
        
        //Get new quantity and item price (including extras)
        let newQuantity = Int(sender.value)
        
        currentOrderItem.setQuantity(quantity: newQuantity)
        
        quantityLabel.text = String(newQuantity)
        setPrice(price: currentOrderItem.price)
        
    }
}
