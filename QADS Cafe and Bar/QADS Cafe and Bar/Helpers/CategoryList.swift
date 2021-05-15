//
//  CategoryList.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 01/02/2021.
//

import UIKit
import FirebaseFirestore

class CategoryList: NSObject {
    
    struct category {
        var name: String?
        var image: String?
        var location: String?
        var order: Int?
    }
    var categories: [category] = []
    
    func getCategories(location: String, Completion: @escaping () -> Void) {
        
        //Refresh list
        categories = []
        
        //Load Firestore Database
        let db = Firestore.firestore()
        
        //Get all active Events
        db.collection("categories").whereField("location", isEqualTo: location).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting categories: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let doc = document.data() as [String : Any]
//                        let ID = document.documentID as String
                        
                        //Construct category
                        var current = category()
                        current.image = doc["image"] as? String
                        current.location = doc["location"] as? String
                        current.name = doc["name"] as? String
                        current.order = doc["order"] as? Int
                        self.categories.append(current)
                    }
                }
                Completion()
        }
    }
    
    func sortButteryCategories() {
        categories.sort { s1, s2 in
            guard let o1 = s1.order, let o2 = s2.order else {
                print("Error: Cannot sort for non buttery categories")
                return true
            }
            return o1 < o2
        }
    }
    
    
    
}
