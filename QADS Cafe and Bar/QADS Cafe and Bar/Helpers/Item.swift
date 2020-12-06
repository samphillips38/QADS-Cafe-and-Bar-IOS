//
//  Item.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit
import FirebaseFirestore

class itemList: NSObject {
    var itemDictionary: [String: Item]? = [:]
    var itemArray: [String]? = []
    
    func loadItemsFor(location: String, category: String, loadItemsForCompletion: @escaping () -> Void) {
        
        //Load Firestore Database
        let db = Firestore.firestore()
        
        //Get all active Events
        db.collection("menuitems").whereField("location", isEqualTo: location).whereField("category", isEqualTo: category)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let doc = document.data() as [String : Any]
                        let ID = document.documentID as String
                        
                        let downloadedItem = Item()
                        downloadedItem.populateItem(ID: ID, doc: doc)
                        
                        self.itemDictionary![ID] = downloadedItem
                        self.itemArray?.append(ID)
                    }
                }
                loadItemsForCompletion()
        }
    }
}


class Item: NSObject {
    var category: String?
    var desc: String?
    var location: String?
    var name: String?
    var options: [String: Bool]?
    var price: Double?
    var stock: Bool?
    
    
    func populateItem(ID: String?, doc: [String: Any?]) {
        self.category = doc["category"] as? String
        self.desc = doc["description"] as? String
        self.location = doc["location"] as? String
        self.name = doc["name"] as? String
        self.options = doc["options"] as? [String: Bool]
        self.price = doc["price"] as? Double
        self.stock = doc["stock"] as? Bool
    }
}
