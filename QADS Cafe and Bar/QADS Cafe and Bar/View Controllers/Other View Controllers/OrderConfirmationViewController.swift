//
//  OrderConfirmationViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 01/02/2021.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Actions
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true) {
            //do something once dismissed
        }
    }
}
