//
//  ItemDetailViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/12/2020.
//

import UIKit

private let reuseIdentifier = "OptionTVC"

class ItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var outOfStockLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToBasketButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //Options
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var chosenItem = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillInData()
        layout()
        
        //stepper settings
        quantityStepper.maximumValue = 10
        quantityStepper.minimumValue = 1
        
        //Table View
        optionTableView.delegate = self
        optionTableView.dataSource = self
    }
    
    
    func layout() {
        
        //Add to basket button
        addToBasketButton.layer.cornerRadius = 20
        addToBasketButton.layer.borderWidth = 1
        addToBasketButton.layer.borderColor = UIColor.blue.cgColor
        
        //Done button
        doneButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        doneButton.layer.cornerRadius = 5
        
        //Table View height
        tableViewHeight.constant = CGFloat(((chosenItem.options ?? [:]).count * 41))
        
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
        
        setPrice(price: chosenItem.price!)
    }
    
    func setPrice(price: Double) {
        priceLabel.text = "Price  £" + String(format: "%.2f", price)
    }
    
    //MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenItem.options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? OptionsTableViewCell else {
            fatalError("The dequeued cell is not an instance of OptionsTableViewCell")
        }
        
        let dict = chosenItem.options!
        cell.setWithDictionary(dict: dict, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Array(chosenItem.options!.keys)[indexPath.row]
        
        chosenItem.options![key] = !(chosenItem.options![key] ?? false)
        
        tableView.reloadRows(at: [indexPath], with: .fade)
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
        let price = Double(Int(sender.value).description)! * chosenItem.price!
        setPrice(price: price)
//        chosenItem.options?["quantity"] = Int(sender.value).description
    }
}
