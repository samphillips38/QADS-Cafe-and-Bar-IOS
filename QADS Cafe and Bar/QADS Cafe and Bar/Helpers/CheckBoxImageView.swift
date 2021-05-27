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
//    var isSelected: Bool = false
    
    func initialise() {
        //Do something
//        print(self.isSelected)
//        if self.isSelected {
//            image = UIImage(named: "checkmark.square")
//        } else {
//            image = UIImage(named: "square")
//        }
    }

    func toggle() {
//        if self.isSelected {
//            image = UIImage(named: "square")
//            isSelected = false
//        } else {
//            image = UIImage(named: "checkmark.square")
//            isSelected = true
//        }
    }
    
    func setSelected(isSelected: Bool) {
        if isSelected {
            image = UIImage(named: "checkmark.square")
        } else {
            image = UIImage(named: "square")
        }
    }
}
