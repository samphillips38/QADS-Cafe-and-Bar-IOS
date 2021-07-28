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
    
    // Order Item
    var thisOrderItem = orderItem()
    var cellType = constants.optionCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func makeCell() {
        if self.cellType == constants.optionCell {
            self.makeOptionCell()
        } else {
            self.makeAllergyCell()
        }
    }
    
    func makeOptionCell() {
        var option = thisOrderItem.options[index!.row]
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
        
    }

    @IBAction func quantityStepper(_ sender: UIStepper) {
        //Get new quantity of extra and update label
        let newQuantity = Int(sender.value)
        self.quantityCount.text = String(newQuantity)
        
        //Send the stepper click to detail view
        cellDelegate?.onStepperClick(index: (index?.row)!, sender: sender)
    }
}
