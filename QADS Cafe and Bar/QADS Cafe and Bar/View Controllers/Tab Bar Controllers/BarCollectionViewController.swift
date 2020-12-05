//
//  BarCollectionViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit

private let reuseIdentifier = "BarCategoryCell"

class BarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up the xib file for the event cells
        let nib = UINib(nibName: "CategoriesCollectionViewCell",bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)

    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return constants.BarCategories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell...
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoriesCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CategoriesCollectionViewCell")
        }
        
        cell.categoryNameLabel.text = constants.BarCategories[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //Make the values constants
        return CGSize(width: collectionView.frame.width * constants.categoryWidthMultiplier, height: collectionView.frame.width * constants.categoryHeightMultiplier)
    }
}
