//
//  DetailsFooterCollectionReusableView.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/05/2021.
//

import UIKit

class DetailsFooterCollectionReusableView: UICollectionReusableView, UITextFieldDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var crsidLabel: UILabel!
    
    @IBOutlet weak var orderNotesTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Text view
        orderNotesTextField.delegate = self
        
        layout()
        
    }
    
    
    func layout() {
        
        //fill in details
        nameLabel.text = currentUser.firstName! + " " + currentUser.lastName!
        emailLabel.text = currentUser.email
        crsidLabel.text = currentUser.crsid
        
    }
    
    
    //MARK: -Text Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentUser.cafeOrder.note = textField.text
        currentUser.barOrder.note = textField.text
    }
    
    
}
