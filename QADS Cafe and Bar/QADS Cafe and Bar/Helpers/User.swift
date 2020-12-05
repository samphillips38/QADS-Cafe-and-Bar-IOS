//
//  User.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit
import Firebase

class User: NSObject {
    var uid: String?
    var crsid: String?
    var basketItems: [String]?
    
    func populate(data: [String: Any?]) {
        self.uid = data["uid"] as? String
        self.crsid = data["crsid"] as? String
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
    
    
    
    func signIn() {
        //Subscribe to topics
//        for eventID in self.myevents ?? [] {
//            Messaging.messaging().subscribe(toTopic: eventID, completion: nil)
//        }
//        Messaging.messaging().subscribe(toTopic: self.uid!, completion: nil)
//        Messaging.messaging().subscribe(toTopic: "general", completion: nil)
    }

}
