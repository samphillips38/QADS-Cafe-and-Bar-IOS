//
//  User.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit
import Firebase
import FirebaseMessaging

class User: NSObject {
    var uid: String?
    var crsid: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var currentOrder = order()
    var previousOrders: [String] = []
    
    func populate(data: [String: Any?]) {
        self.uid = data["uid"] as? String
        self.crsid = data["crsid"] as? String
        self.previousOrders = data["previous_orders"] as? [String] ?? []
        self.firstName = data["firstname"] as? String
        self.lastName = data["lastname"] as? String
        self.email = data["email"] as? String
    }
    
    func populateAsCurrentUser(populateAsCurrentUserCompletion: @escaping () -> Void) {
        
        if (Auth.auth().currentUser?.uid) == nil {
            print("Could not populate as Current user: No User Logged in")
            return
        }
        
        //Load Firestore Database
        let db = Firestore.firestore()
                
        //Get User
        let uid = (Auth.auth().currentUser?.uid)!
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, err) in
            
            if err != nil {
                print("Error getting documents: \(String(describing: err))")
            } else {
                if let document = document, document.exists {

                    //Load the user data into the user object
                    if let data = document.data() {
                        self.populate(data: data)
                    }
                    
                } else {
                    print("Document does not exist")
                }
            }
            populateAsCurrentUserCompletion()
        }
    }
    
    
    func addToPreviousOrders(order: order, completion: @escaping () -> Void) {
        
        //Return if order does not yet exist
        if order.orderID == nil {
            return
        }
        
        //Save order
        self.previousOrders.append(order.orderID!)
        
        //Upload information to Firebase
        let db = Firestore.firestore()
        let orderRef = db.collection("users").document(self.uid!)
        
        orderRef.updateData([
            "previous_orders": self.previousOrders
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Event successfully updated")
            }
            completion()
        }
        
    }
    
    
    func signIn() {
        //Subscribe to topics
        Messaging.messaging().subscribe(toTopic: self.uid!, completion: nil)
        Messaging.messaging().subscribe(toTopic: self.crsid!, completion: nil)
    }
    
    func make(completion: @escaping () -> Void) {
        
        //Upload information to Firebase
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let email = (Auth.auth().currentUser!.email)
        let crsid = email?.components(separatedBy: "@")[0]
        
        db.collection("users").document(uid!).setData([
            "uid": uid!,
            "crsid": crsid ?? "UNKNOWN",
            "email": email ?? "UNKNOWN",
            "firstname": self.firstName as Any,
            "lastname": self.lastName as Any
        ]) { (error) in
            if error != nil {
                //show error message
                print("There was an error: ", error ?? "UNKNOWN")
            }
            
            //Now save details
            self.uid = uid
            self.email = email
            self.crsid = crsid
            
            completion()
        }
        
    }

}
