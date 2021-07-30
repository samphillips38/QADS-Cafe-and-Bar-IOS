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
        
        navigationItem.title = category
        
        //Load in data
        ItemList.loadItemsFor(location: location, category: category) {
            self.collectionView.reloadData()
        }
        
    }
    
    
    // MARK:- Collection View
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
        
        var currentItem = ItemList.itemDictionary![ItemList.itemArray![indexPath.row]]!
        
        cell.loadDataFromObject(item: currentItem) {
            //Do something on completion
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //Make the values constants
        return CGSize(width: collectionView.frame.width * constants.itemWidthMultiplier, height: collectionView.frame.width * constants.itemHeightMultiplier)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ItemDetailVC = storyBoard.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailsViewController

        ItemDetailVC.chosenItem = ItemList.itemDictionary![ItemList.itemArray![indexPath.row]]!
        present(ItemDetailVC, animated: true, completion: nil)
    }
    

}
