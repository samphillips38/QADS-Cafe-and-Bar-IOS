//
//  OptionsTableViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/12/2020.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    @IBOutlet weak var stepperStackView: UIStackView!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBox.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
//        if selected {
//            checkBox.isHidden = false
//        } else {
//            checkBox.isHidden = true
//        }
        
    }
    
    func setWithDictionary(options: [orderItem.Option], index: Int) {
        
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
        
        //Get new quantity of extra
        let newQuantity = Int(sender.value).description
        
        self.quantityLabel.text = newQuantity
        
        //Update the order
        
//        guard let itemVC = self.superview?.superview?.superview?.superview as? ItemDetailViewController else {
//            fatalError()
//        }
//
//        print(itemVC.tempOrder.items[0])
    
        print(newQuantity)
        
    }
}
