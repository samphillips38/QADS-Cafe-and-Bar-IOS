//
//  OptionsTableViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/12/2020.
//

import UIKit

//Protocol for cell Delegate (item detail view)
protocol cellDelegate{
    func onStepperClick(index: Int, sender: UIStepper)
}

class OptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    @IBOutlet weak var stepperStackView: UIStackView!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    //Set up delegate and index
    var cellDelegate: cellDelegate?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setOptions(options: [orderItem.Option], index: Int) {
        
        //Get option and layout cell
        let option = options[index]
        self.optionLabel.text = option.name

        //Show check box or stepper
        if option.canHaveMultiple {
            stepperStackView.isHidden = false
            checkBox.isHidden = true
        } else {
            stepperStackView.isHidden = true
            checkBox.isHidden = false
        }
        
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        
        //Get new quantity of extra and update label
        let newQuantity = Int(sender.value)
        self.quantityLabel.text = String(newQuantity)
        
        //Send the stepper click to detail view
        cellDelegate?.onStepperClick(index: (index?.row)!, sender: sender)
        
    }
}
