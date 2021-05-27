//
//  Order.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/01/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFunctions

class order: NSObject {
    var orderID: String?
    var archived = false
    var cancelled = false
    var email: String?
    var flagged = false
    var items: [orderItem] = []
    var location: String?
    var orderDate: Date?
    var price: Double = 0.0
    var userCRSID: String?
    var note: String?
    var name: String?
    
    lazy var functions = Functions.functions()
    
    func addItem(item: orderItem) {
        price = price + item.price
        items.append(item)
    }
    
    func removeItemAt(index: Int) {
        price = price - items[index].price
        items.remove(at: index)
    }
    
    func checkoutOrder(completion: @escaping () -> Void) {
        
        //get email and name
        self.email = Auth.auth().currentUser?.email
        self.name = (currentUser.firstName ?? "") + " " + (currentUser.lastName ?? "")
        
        if self.orderID == nil {
            //This is a new order
            self.saveOrder {
                currentUser.addToPreviousOrders(order: self) {
                    completion()
                }
            }
        } else {
            //This order already exists
            self.updateOrder {
                completion()
            }
        }
        
    }
    
    func saveOrder(completion: @escaping () -> Void) {
        
        //Set the time of order
        let date = Date()
        self.orderDate = date
        
        //Configure Data
        let dataDic = makeDataDictionary()
        
        //Upload information to Firebase
        let db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        ref = db.collection("orders").addDocument(data: dataDic) { (error) in
            if error != nil {
                print("Error creating document: ", error!)
            } else {
                self.orderID = ref!.documentID
            }
            completion()
        }
    }
    
    func updateOrder(completion: @escaping () -> Void) {
        
        //If document does not already exist, return
        if self.orderID == nil {
            return
        }
        
        //Configure Data
        let dataDic = makeDataDictionary()
        
        //Upload information to Firebase under existing document
        let db = Firestore.firestore()
        let orderRef = db.collection("orders").document(self.orderID!)
        
        orderRef.updateData(dataDic) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Order successfully updated")
            }
            completion()
        }
    }
    
    
    func makeDataDictionary() -> [String: Any] {
        //Create a dictionary in the correct format for saving in firebase
        
        //Get properly formatted item list
        let configuredItems = self.configureItems()
        
        let dataDic = [
            "archived": self.archived,
            "cancelled": self.cancelled,
            "email": self.email as Any,
            "flagged": self.flagged,
            "items": configuredItems,
            "location": self.location as Any,
            "order_datetime": self.orderDate as Any,
            "price": self.price,
            "user": currentUser.crsid as Any,
            "note": self.note as Any,
            "name": self.name as Any
        ]
        
        return dataDic
    }
    
    func configureItems() -> [[String: Any]] { //Returns Configured Cafe then Bar Lists
        
        //Configure the item Dictionary for Bar and Cafe
        var configuredItems: [[String: Any]] = []
        
        for item in self.items {
            
            //Add multiple if more than one quantity
            for _ in 1...item.quantity {
                
                var itemDic: [String: Any] = [:]
                
                itemDic["id"] = item.itemID
                itemDic["name"] = item.itemName
                self.location = item.location //Ensures that the order is set to the correct location
                
                //set options Dictionary
                var optionsDic: [String: Any] = [:]
                for option in item.options {
                    optionsDic[option.name] = [
                        "name":option.name,
                        "quantity": option.quantity
                    ]
                }
                itemDic["options"] = optionsDic
                
                //Add item
                configuredItems.append(itemDic)
                
            }
        }
        return configuredItems
    }
    
    func resetOrder() {
        
        //Reset all to defaults
        let new = order()
        
        self.orderID = new.orderID
        self.archived = new.archived
        self.cancelled = new.cancelled
        self.email = new.email
        self.flagged = new.flagged
        self.items = new.items
        self.location = new.location
        self.orderDate = new.orderDate
        self.price = new.price
        self.userCRSID = new.userCRSID
        self.note = new.note
        self.name = new.name
        
    }
    
}





class orderItem: NSObject {
    //This class is used when creating an order item, before adding it to the basket
    var refItem = Item()
    var itemID: String?
    var itemName: String?
//    var note: String = ""
    var location: String?
    var allergies: [String] = []
    var chosenAllergies: [String] = []
    
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
        location = item.location
        
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
        
        //Update price and round to 2 dp
        self.price = price * Double(self.quantity)
        self.price = (self.price * 100).rounded() / 100
    }
    
    func getAllergenList(completion: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        db.collection("settings").document("allergies").getDocument { (document, err) in
            if err != nil {
                print("Error getting documents: \(String(describing: err))")
            } else {
                if let document = document, document.exists {
                    //Fill in allergy data
                    self.allergies = (document["allergies"] as? [String]) ?? []
                } else {
                    print("Document does not exist")
                }
            }
            completion()
        }
    }
    
}
