//
//  TestTableViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 13/06/2021.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBox: CheckBoxImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setOption(option: orderItem.Option) {
        
        self.nameLabel.text = option.name
        self.priceLabel.text = "+ £" + String(format: "%.2f", option.extraPrice)
        checkBox.setSelected(setTo: option.quantity != 0)
        
    }
    
    
    
    

}
