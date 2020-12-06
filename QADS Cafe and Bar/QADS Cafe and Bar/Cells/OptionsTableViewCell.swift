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
    
    func setWithDictionary(dict: [String: Bool], index: Int) {
        
        self.optionLabel.text = Array(dict.keys)[index]
        
        if dict[(Array(dict.keys))[index]] ?? false {
            checkBox.isHidden = false
        } else {
            checkBox.isHidden = true
        }
    }
    
}
