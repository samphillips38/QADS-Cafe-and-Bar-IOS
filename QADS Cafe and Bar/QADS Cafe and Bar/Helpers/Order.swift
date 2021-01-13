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
    var items: [[String: Any]] = [[:]]
    var location: String?
    var orderDate: Date?
    var price: Double? = 0.0
    var usrCRSID: String?

    
    func startOrder(item: Item) {
        
        //Construct options from Item with defaults filled in
        var optionsDic: [String: [String: Any]] = [:]
        for (option, optionInfo) in item.options ?? [:] {
            optionsDic[option] = optionInfo
            optionsDic[option]?["quantity"] = 0
        }
        
        //Construct the item to be added to the order
        let orderItem: [String: Any] = [
            "id": item.id as Any,
            "name": item.name as Any,
            "note": "",
            "options": optionsDic,
            "price": item.price ?? 0
        ]
        
        //Add item to the order
        self.items = [orderItem]
        self.price = item.price ?? 0 + (self.price ?? 0)
        
    }
    
}



class orderItem: NSObject {
    //This class is used when creating an order item, before adding it to the basket
    var refItem = Item()
    var itemID: String?
    var itemName: String?
    var note: String = ""
//    var options: [String: [String: Any]] = [:]
    
    //try struct
    struct Option {
        var name: String
        var canHaveMultiple: Bool
        var extraPrice: Double
        var quantity: Int
    }
    
    var options: [Option] = []
    
    var price: Double = 0.0
    var quantity: Int = 1
    
    func createOrderItem(item: Item) {
        refItem = item
        itemID = item.id
        itemName = item.name
        price = item.price ?? 0.0
        
        //make options dictionary
        for (option, optionInfo) in item.options ?? [:] {
//            options[option] = optionInfo
//            options[option]?["quantity"] = 0
            
            
            
            let thisOption = Option(
                name: optionInfo["name"] as! String,
                canHaveMultiple: optionInfo["can_have_multiple"] as! Bool,
                extraPrice: optionInfo["extra_price"] as! Double,
                quantity: 1
                )
            
            self.options.append(thisOption)
            
        }
    }
    
    
    func setQuantity(quantity: Int) {
        //Change price
        
        //Price for one
        var price = refItem.price ?? 0
        
        
        
        
    }
    
}
