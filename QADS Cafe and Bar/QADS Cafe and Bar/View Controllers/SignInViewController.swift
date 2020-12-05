//
//  SignInViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var SignInRaven: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add gesture recogniser to view
        SignInRaven.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signInTapped(_:))))
        
        //Allow pop up to be presented
        GIDSignIn.sharedInstance()?.hostedDomain = nil
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Do any additional setup after loading the view.
    }
    

    @objc func signInTapped(_ sender: UITapGestureRecognizer? = nil) {

        //Google Sign In PopUp with raven
        GIDSignIn.sharedInstance().signIn()
    }

}
