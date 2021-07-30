//
//  OptionTableViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 13/06/2021.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBox: CheckBoxImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityCount: UILabel!
    
    //Set up delegate and index
//    var cellDelegate: optionsCellDelegate?
    var index: IndexPath?
    var typeIndex = -1
    
    // Order Item
    var currentOrderItem = orderItem()
    var cellType = constants.optionCell
    
    var onQuantityChange = {}
    
    private var option = orderItem.Option()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func makeCell() {
        if cellType == constants.optionCell {
            option = currentOrderItem.options[index!.row]
            makeOptionCell()
        } else if cellType == constants.typeCell {
            let type = currentOrderItem.types[typeIndex]
            option = type.choices[index!.row]
            makeOptionCell()
        } else if cellType == constants.allergyCell {
            makeAllergyCell()
        }
    }
    
    func makeOptionCell() {
        self.nameLabel.text = option.name
        self.priceLabel.text = "+ £" + String(format: "%.2f", option.extraPrice)
        
        if option.canHaveMultiple {
            quantityStepper.isHidden = false
            quantityCount.isHidden = false
            quantityCount.text = String(option.quantity)
        } else {
            checkBox.setSelected(setTo: option.quantity != 0)
        }
    }
    
    func makeAllergyCell() {
        // Make the cell
        let allergy = currentOrderItem.allergies[index?.row ?? 0]
        self.nameLabel.text = allergy.name
        checkBox.setSelected(setTo: allergy.isChosen)
    }

    @IBAction func quantityStepper(_ sender: UIStepper) {
        //Get new quantity of extra and update label
        currentOrderItem.options[(index?.row)!].quantity = Int(sender.value)
        currentOrderItem.updatePrice()
        makeCell()
        onQuantityChange()
    }
}
