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
    var refreshCell = {}
    
    func setUp() {
        titleLabel.text = "Choose Allergies"
        chosenAllergiesLabel.text = getChosenAllergies()
        
        // Add gesture recogniser for cell
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseAllergiesTapped(_:))))
    }
    
    func setUpAndRefresh() {
        setUp()
        refreshCell()
    }
    
    func getChosenAllergies() -> String {
        var text = "Chosen Allergies: "
        var noneFound = true
        for allergy in currentOrderItem.allergies {
            if allergy.isChosen {
                text += allergy.name + ", "
                noneFound = false
            }
        }
        if noneFound {
            return "No Allergies Added"
        } else {
            return String(text.dropLast(2))
        }
    }
    
    
    @objc func chooseAllergiesTapped(_ sender: UITapGestureRecognizer? = nil) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AllergyVC = storyBoard.instantiateViewController(withIdentifier: "AllergiesVC") as! AllergyPickerViewController
        AllergyVC.currentOrderItem = currentOrderItem
        AllergyVC.onDismiss = {self.setUpAndRefresh()}
        presentVC(AllergyVC)
        AllergyVC.setUp()
    }
    
    @IBAction func addAllergyTapped(_ sender: Any) {
        chooseAllergiesTapped()
    }
}
