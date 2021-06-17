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
    var isSelected: Bool = false
    
    func initialise() {
        self.image = UIImage(systemName: "circle")
    }
    
    func setSelected(setTo: Bool) {
        self.isSelected = setTo
        if isSelected {
            image = UIImage(systemName: "circle.fill")
        } else {
            image = UIImage(systemName: "circle")
        }
    }
    
    func toggle() {
        if self.isSelected {
            self.isSelected = false
            image = UIImage(systemName: "circle")
        } else {
            self.isSelected = true
            image = UIImage(systemName: "circle.fill")
        }
    }
}
