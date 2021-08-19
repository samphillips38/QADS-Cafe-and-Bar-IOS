//
//  DetailsCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 17/08/2021.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var crsidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //fill in details
        nameLabel.text = currentUser.firstName! + " " + currentUser.lastName!
        emailLabel.text = currentUser.email
        crsidLabel.text = currentUser.crsid
    }
    
}
