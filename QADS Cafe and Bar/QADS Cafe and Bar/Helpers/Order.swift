//
//  Order.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/01/2021.
//

import UIKit

class order: NSObject {
    var archived = false
    var cancelled = false
    var email: String?
    var flagged = false
    var items: [orderItem] = []
    var location: String?
    var orderDate: Date?
    var price: Double = 0.0
    var usrCRSID: String?
    
    func addItem(item: orderItem) {
        price = price + item.price
        items.append(item)
    }
    
    func removeItemAt(index: Int) {
        price = price - items[index].price
        items.remove(at: index)
    }
    
}





class orderItem: NSObject {
    //This class is used when creating an order item, before adding it to the basket
    var refItem = Item()
    var itemID: String?
    var itemName: String?
    var note: String = ""
    
    //Create a struct for an option. These will be stored in an array
    struct Option {
        var name: String = ""
        var canHaveMultiple: Bool = false
        var extraPrice: Double = 0.0
        var quantity: Int = 0
    }
    var options: [Option] = []
    var price: Double = 0.0
    var quantity: Int = 1
    
    
    
    func createOrderItem(item: Item) {
        refItem = item
        itemID = item.id
        itemName = item.name
        price = item.price ?? 0.0
        
        //make options Array
        for (_, optionInfo) in item.options ?? [:] {
            
            //Create Option struct and append
            let thisOption = Option(
                name: optionInfo["name"] as! String,
                canHaveMultiple: optionInfo["can_have_multiple"] as! Bool,
                extraPrice: optionInfo["extra_price"] as! Double,
                quantity: 0
                )
            
            self.options.append(thisOption)
            
        }
    }
    
    
    func setQuantity(quantity: Int) {
        //Change price and quantity
        self.quantity = quantity
        self.updatePrice()
    }
    
    func updatePrice() {
        
        //Price for one (item plus any extras)
        var price = refItem.price ?? 0
        for option in options {
            price = price + (option.extraPrice * Double(option.quantity))
        }
        
        //Update price
        self.price = price * Double(self.quantity)
    }
    
}
