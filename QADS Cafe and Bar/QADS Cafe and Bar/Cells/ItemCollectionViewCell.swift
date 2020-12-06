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
    
    var item = Item()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layout()
    }

    func layout() {
        
        //MainView Layout
        mainView.layer.cornerRadius = 20
        mainView.clipsToBounds = true
    }
    
    
    func loadDataFromObject(item: Item, loadDataFromObjectCompletion: @escaping () -> Void) {
        
        //Fill in data
        itemLabel.text = item.name
        if item.stock ?? true {
            stockLabel.isHidden = true
        } else {
            stockLabel.isHidden = false
            stockLabel.text = "This item is out of stock"
        }
    }
    
    
}
