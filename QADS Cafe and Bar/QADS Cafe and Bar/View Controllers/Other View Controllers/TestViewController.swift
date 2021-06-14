//
//  TestViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/06/2021.
//

import UIKit

private let reuseIdentifier = "TestID"

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var chosenItem = Item()
    var pageList: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func constructPageList() {
        pageList.append("Title")
        
    }
    
    
    
    // MARK:- Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell...
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TestCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
        }
        cell.setUp()
        cell.cellDic = chosenItem.options ?? [:]
        cell.collectionViewRow = indexPath.row
        cell.numRows = indexPath.row * (indexPath.row + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
        }
        let height = cell.rowHeight * CGFloat(cell.numRows) + 36
        print(height)

        //Make the values constants
        return CGSize(width: collectionView.frame.width * constants.itemWidthMultiplier, height: height)
    }
    

}
