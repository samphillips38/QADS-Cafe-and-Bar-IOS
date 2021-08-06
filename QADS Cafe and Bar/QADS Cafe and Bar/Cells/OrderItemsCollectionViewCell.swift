//
//  OrderItemsCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/05/2021.
//

import UIKit

//Protocol for cell delegate
protocol orderItemsDelegate {
    func deleteItemTapped(index: Int)
}

class OrderItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var cellDelegate: orderItemsDelegate?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func fillInData(item: orderItem) {
        
        itemNameLabel.text = item.itemName
        itemPriceLabel.text = "£" + String(format: "%.2f", item.price)
        quantityLabel.text = "x" + String(item.quantity)
        descriptionLabel.text = getDetails(item: item)
    }
    
    
    func getDetails(item: orderItem) -> String {
        var text = "Details:"
        
        // Types
        for type in item.types {
            for choice in type.choices {
                if choice.quantity > 0 {
                    text += "\n" + type.name + ": " + choice.name
                }
            }
        }
        
        // Options
        for option in item.options {
            if option.quantity > 0 {
                text += "\n" + option.name + ": " + String(option.quantity)
            }
        }
        
        //Allergies
        var AllergyList: [String] = []
        for allergy in item.allergies {
            if allergy.isChosen {
                AllergyList.append(allergy.name)
            }
        }
        if AllergyList != [] {
            text += "\n\nAllergies: \n"
            text += AllergyList.joined(separator: "\n")
        }
        
        // Check if empty
        if text == "Details:" {
            text = "No Details"
        }
        return text
    }

    //MARK: -Button Actions
    
    @IBAction func deleteButton(_ sender: Any) {
        cellDelegate?.deleteItemTapped(index: index!.row)
    }
    
}
