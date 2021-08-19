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
        layout()
    }
    
    func layout() {
        //fill in details
        nameLabel.text = currentUser.firstName! + " " + currentUser.lastName!
        emailLabel.text = currentUser.email
        crsidLabel.text = currentUser.crsid
    }
}
