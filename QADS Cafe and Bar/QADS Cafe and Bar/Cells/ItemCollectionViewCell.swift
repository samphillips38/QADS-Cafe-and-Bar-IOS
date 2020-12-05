//
//  ItemCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    
    var item = Item()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemLabel.text = item.name
    }

}
