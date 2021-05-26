//
//  AllergiesTableViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 24/05/2021.
//

import UIKit

class AllergiesTableViewCell: UITableViewCell {

//    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var allergiesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        checkBox.initialise()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        checkBox.selected()
    }

}
