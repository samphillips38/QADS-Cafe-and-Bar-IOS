//
//  CheckBox.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 24/05/2021.
//

import UIKit

class CheckBoxImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func initialise() {
        //Do something
        image = UIImage(named: "square")
    }
    
    func selected() {
        image = UIImage(named: "checkmark.square")
    }
    func deselected() {
        image = UIImage(named: "square")
    }

}
