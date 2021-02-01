//
//  CategoriesCollectionViewCell.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImage: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layout()
    }
    
    func layout() {
        
        //MainView Layout
        mainView.layer.cornerRadius = 20
        mainView.clipsToBounds = true
        
        //Add shadow
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowRadius = 3
        self.clipsToBounds = false
    }
    
    func fillInWithCategory(category: CategoryList.category, Completion: @escaping () -> Void) {
        
        categoryNameLabel.text = category.name
        
        let imageRef = "categories/" + (category.image ?? "")
        
        //get Category Image (from cache if possible) and set
        self.categoryImage.LoadImageUsingCache(ImageRef: imageRef) { (isFound) in
            
            //Image not found
            if isFound == false {
                print("error finding Category Image")
            }
            Completion()
        }
        
        
    }

}
