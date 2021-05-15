//
//  OrderItemsCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/05/2021.
//

import UIKit

//Protocol for cell delegate
//protocol orderItemsDelegate {
//    func deleteItemTapped(index: Int)
//}

class OrderItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var cellDelegate: orderItemsDelegate?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemNameLabel.text = "Something"
    }
    
    
    func fillInData(item: orderItem) {
        
        itemNameLabel.text = item.itemName
        itemPriceLabel.text = "£" + String(format: "%.2f", item.price)
        quantityLabel.text = "x" + String(item.quantity)
    }

    //MARK: -Button Actions
    
    @IBAction func deleteButton(_ sender: Any) {
        cellDelegate?.deleteItemTapped(index: index!.row)
    }
    
}
