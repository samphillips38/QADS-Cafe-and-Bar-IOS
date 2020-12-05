//
//  ItemsViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit

private let reuseIdentifier = "ItemCell"

class ItemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var ItemList = itemList()
    var location = String()
    var category = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup for collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Set up the xib file for the event cells
        let nib = UINib(nibName: "ItemCollectionViewCell",bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        titleLabel.text = location
        
        ItemList.loadItemsFor(location: location, category: category) {
            self.collectionView.reloadData()
        }
        
    }
    
    
    // MARK: Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemList.itemArray?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell...
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of ItemCollectionViewCell")
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //Make the values constants
        return CGSize(width: collectionView.frame.width * constants.categoryWidthMultiplier, height: collectionView.frame.width * constants.categoryHeightMultiplier)
    }
    
}
