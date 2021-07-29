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
    var currentOrderItem = orderItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        currentOrderItem.createOrderItem(item: chosenItem)
        currentUser.getAllergenList {
            self.collectionView.reloadData()
        }
    }
    
    func getCellType(indexPath: IndexPath) -> Int {
        if indexPath.row == 0 {
            return constants.titleCell
        } else if indexPath.row == 1 {
            return constants.optionCell
        } else if 0 <= indexPath.row-2 && indexPath.row-2 < currentOrderItem.types.count {
            return constants.typeCell
        } else {
            return constants.allergyCell
        }
    }
    
    
    // MARK:- Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Add one for title, one for options
        return currentOrderItem.types.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        if getCellType(indexPath: indexPath) == constants.titleCell { // This is the title cell
            
            // Configure cell for title
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestTitleCVC", for: indexPath) as? TestTitleCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestTitleCollectionViewCell")
            }
            cell.fillInData(chosenItem: self.chosenItem)
            return cell
            
        } else if getCellType(indexPath: indexPath) == constants.optionCell { // This is the Options cell
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.cellType = constants.optionCell
            cell.index = indexPath
            cell.currentOrderItem = currentOrderItem
            cell.setUp()
            return cell
            
        } else if getCellType(indexPath: indexPath) == constants.typeCell { // This is a Type
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.cellType = constants.typeCell
            cell.index = indexPath
            cell.currentOrderItem = currentOrderItem
            cell.setUp()
            return cell
            
        } else if getCellType(indexPath: indexPath) == constants.allergyCell { // This is an Allergy Cell
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllergyCVC", for: indexPath) as? TestAllergensCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestAllergensCollectionViewCell")
            }
            cell.allergyList = currentUser.allergies
            cell.setUp()
            return cell
            
        }
        
        return cell
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = CGFloat()
        
        if getCellType(indexPath: indexPath) == constants.titleCell {

            height = constants.itemTitleHeight
            
        } else if getCellType(indexPath: indexPath) == constants.optionCell {
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }

            //Set height based on table view height
            let optionList = currentOrderItem.options
            height = getCellHeight(optionList: optionList, rowHeight: cell.rowHeight, offset: constants.optionTVOffset)
            
        } else if getCellType(indexPath: indexPath) == constants.typeCell {
            
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            
            let type = currentOrderItem.types[indexPath.row - 2]
            height = getCellHeight(optionList: type.choices, rowHeight: cell.rowHeight, offset: constants.optionTVOffset)
        } else if getCellType(indexPath: indexPath) == constants.allergyCell {
            
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestAllergensCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestAllergensCollectionViewCell")
            }
            
            height = getCellHeight(optionList: currentUser.allergies, rowHeight: cell.rowHeight, offset: constants.allergyTVOffset)
            
        }
        
        //Set Cell size
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func getCellHeight(optionList: [Any]?, rowHeight: CGFloat, offset: CGFloat) -> CGFloat {
        let numRows = (optionList ?? []).count
        let height = rowHeight * CGFloat(numRows)
        return height + offset
    }
    

}
