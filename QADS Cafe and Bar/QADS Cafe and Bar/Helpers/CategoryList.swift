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
    }
    var categories: [category] = []
    
    
    func getCafeCategories(Completion: @escaping () -> Void) {
        
        //Refresh list
        categories = []
        
        //Load Firestore Database
        let db = Firestore.firestore()
        
        //Get all active Events
        db.collection("categories").whereField("open", isEqualTo: true).whereField("location", isEqualTo: "Cafe").getDocuments() { (querySnapshot, err) in
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
                        self.categories.append(current)
                    }
                }
                Completion()
        }
    }
    
    
    func getBarCategories(Completion: @escaping () -> Void) {
        
        //Refresh list
        categories = []
        
        //Load Firestore Database
        let db = Firestore.firestore()
        
        //Get all active Events
        db.collection("categories").whereField("open", isEqualTo: true).whereField("location", isEqualTo: "Bar").getDocuments() { (querySnapshot, err) in
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
                        self.categories.append(current)
                    }
                }
                Completion()
        }
    }
    
    
}
