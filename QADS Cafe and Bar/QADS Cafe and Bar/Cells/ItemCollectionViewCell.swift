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
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item = Item()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layout()
    }

    func layout() {
        
        //Nothing yet
        
    }
    
    
    func loadDataFromObject(item: Item, loadDataFromObjectCompletion: @escaping () -> Void) {
        
        //Fill in data
        itemLabel.text = item.name
        descriptionLabel.text = item.desc
        priceLabel.text = "£" + String(format: "%.2f", item.price ?? 0.0)
        
        if item.stock ?? true {
            stockLabel.isHidden = true
        } else {
            stockLabel.isHidden = false
            stockLabel.text = "This item is out of stock"
        }
        
        
    }
    
    
}
