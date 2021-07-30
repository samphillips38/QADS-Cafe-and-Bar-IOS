//
//  AllergensCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 17/06/2021.
//

import UIKit

class AllergensCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chosenAllergiesLabel: UILabel!
    
    var currentOrderItem = orderItem()
    var presentVC = {(VC: UIViewController) -> Void in }
    
    func setUp() {
        titleLabel.text = "Choose Allergies"
        setChosenAllergies()
        
        // Add gesture recogniser for cell
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseAllergiesTapped(_:))))
    }
    
    func setChosenAllergies() {
        var text = "Chosen Allergies: "
        var noneFound = true
        for allergy in currentOrderItem.allergies {
            if allergy.isChosen {
                text += allergy.name + ", "
                noneFound = false
            }
        }
        if noneFound {
            chosenAllergiesLabel.text = "No Allergies Added"
        } else {
            chosenAllergiesLabel.text = String(text.dropLast(2))
        }
    }
    
    
    @objc func chooseAllergiesTapped(_ sender: UITapGestureRecognizer? = nil) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AllergyVC = storyBoard.instantiateViewController(withIdentifier: "AllergiesVC") as! AllergyPickerViewController
        AllergyVC.currentOrderItem = currentOrderItem
        AllergyVC.onDismiss = {self.setChosenAllergies()}
        presentVC(AllergyVC)
        AllergyVC.setUp()
    }
    
    @IBAction func addAllergyTapped(_ sender: Any) {
        chooseAllergiesTapped()
    }
}
