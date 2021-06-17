//
//  TestTitleCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 14/06/2021.
//

import UIKit

class TestTitleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var allergenLabel: UILabel!
    
    func makeAllergenLabel(allergenList: [String]?) -> String {
        //If allergens not found, display warning message
        guard let allergenList = allergenList else {
            return "Error, no allergen data received. Please contact catering staff."
        }
        //If no allergens are found, display No Allergens
        if allergenList[0] == "no allergens" || allergenList.isEmpty {
            return "No Allergens."
        }
        //Construct output
        var output = "Contains "
        for (i, allergen) in allergenList.enumerated() {
            if i == allergenList.count - 1 {
                output = output.dropLast(2) + " and " + allergen + "."
            } else {
                output = output + allergen + ", "
            }
        }
        return output
    }
    
}
