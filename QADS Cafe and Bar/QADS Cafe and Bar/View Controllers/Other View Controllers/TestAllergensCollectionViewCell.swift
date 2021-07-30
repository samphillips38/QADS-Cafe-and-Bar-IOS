//
//  TestAllergensCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 17/06/2021.
//

import UIKit

class TestAllergensCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chosenAllergiesLabel: UILabel!
    
    var currentOrderItem = orderItem()
    var presentVC = {(VC: UIViewController) -> Void in }
    
    func setUp() {
        titleLabel.text = "Choose Allergies"
        setChosenAllergies()
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
            chosenAllergiesLabel.text = "No Allergies Chosen"
        } else {
            chosenAllergiesLabel.text = String(text.dropLast(2))
        }
    }
    
    @IBAction func selectAllergiesTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AllergyVC = storyBoard.instantiateViewController(withIdentifier: "OptionsVC") as! OptionPickerViewController
        AllergyVC.currentOrderItem = currentOrderItem
        AllergyVC.onDismiss = {self.setChosenAllergies()}
        presentVC(AllergyVC)
        AllergyVC.setUp()
    }
    
}
