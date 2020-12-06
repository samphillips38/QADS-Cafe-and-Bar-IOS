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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Allow pop up to be presented
        GIDSignIn.sharedInstance()?.hostedDomain = nil
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Do any additional setup after loading the view.
    }

}
