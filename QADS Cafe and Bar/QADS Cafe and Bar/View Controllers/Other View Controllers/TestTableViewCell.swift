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
    
    var option = orderItem.Option()
    
    //Set up delegate and index
    var cellDelegate: optionsCellDelegate?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillInData() {
        self.nameLabel.text = option.name
        self.priceLabel.text = "+ £" + String(format: "%.2f", option.extraPrice)
        checkBox.setSelected(setTo: option.quantity != 0)
        
        if option.canHaveMultiple {
            quantityStepper.isHidden = false
            quantityCount.isHidden = false
            checkBox.isHidden = true
        }
    }

    @IBAction func quantityStepper(_ sender: UIStepper) {
        //Get new quantity of extra and update label
        let newQuantity = Int(sender.value)
        self.quantityCount.text = String(newQuantity)
        
        //Send the stepper click to detail view
        cellDelegate?.onStepperClick(index: (index?.row)!, sender: sender)
    }
}
