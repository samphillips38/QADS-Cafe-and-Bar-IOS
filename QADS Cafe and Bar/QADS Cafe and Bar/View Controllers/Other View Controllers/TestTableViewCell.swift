//
//  TestTableViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 13/06/2021.
//

import UIKit


//Protocol for cell Delegate (item detail view)
protocol TestOptionsCellDelegate{
    func onStepperClick(index: Int, sender: UIStepper)
}

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBox: CheckBoxImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityCount: UILabel!
    
    //Set up delegate and index
    var cellDelegate: optionsCellDelegate?
    var index: IndexPath?
    var typeIndex: Int?
    
    // Order Item
    var thisOrderItem = orderItem()
    var cellType = constants.optionCell
    
    private var option = orderItem.Option()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func makeCell() {
        if cellType == constants.optionCell {
            option = thisOrderItem.options[index!.row]
            makeOptionCell()
        } else if cellType == constants.typeCell {
            let type = thisOrderItem.types[typeIndex!]
            option = type.choices[index!.row]
            makeOptionCell()
        } else {
            makeAllergyCell()
        }
    }
    
    func makeOptionCell() {
        self.nameLabel.text = option.name
        self.priceLabel.text = "+ £" + String(format: "%.2f", option.extraPrice)
        
        if option.canHaveMultiple {
            quantityStepper.isHidden = false
            quantityCount.isHidden = false
        } else {
            checkBox.setSelected(setTo: option.quantity != 0)
        }
    }
    
    func makeAllergyCell() {
        // Make the cell
    }

    @IBAction func quantityStepper(_ sender: UIStepper) {
        //Get new quantity of extra and update label
        let newQuantity = Int(sender.value)
        self.quantityCount.text = String(newQuantity)
        
        //Send the stepper click to detail view
        cellDelegate?.onStepperClick(index: (index?.row)!, sender: sender)
    }
}
