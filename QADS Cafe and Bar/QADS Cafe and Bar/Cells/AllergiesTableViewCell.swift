//
//  AllergiesTableViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 24/05/2021.
//

import UIKit

class AllergiesTableViewCell: UITableViewCell {

    @IBOutlet weak var allergiesLabel: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
