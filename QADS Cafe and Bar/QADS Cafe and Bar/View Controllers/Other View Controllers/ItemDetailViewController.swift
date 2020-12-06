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
    
    var chosenItem = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemNameLabel.text = chosenItem.name
        descriptionLabel.text = chosenItem.desc
        
        if chosenItem.stock ?? false {
            outOfStockLabel.isHidden = true
        } else {
            outOfStockLabel.isHidden = false
            outOfStockLabel.text = "This item is out of stock."
        }
    }

}
