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
    var pageList: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        currentOrderItem.createOrderItem(item: chosenItem)
        currentOrderItem.getAllergenList {
            self.constructPageList()
            self.collectionView.reloadData()
        }
    }
    
    func constructPageList() {
        
        // Title
        pageList.append([constants.titleStr: currentOrderItem.itemName])
        
        // Option
        if !currentOrderItem.options.isEmpty {
            pageList.append([constants.optionStr: currentOrderItem.options])
        }
        
        // Types
        for type in currentOrderItem.types {
            pageList.append([constants.typeStr: type])
        }
        
        // Allergies
        if !currentOrderItem.allergies.isEmpty {
            pageList.append(["Allergies": currentOrderItem.allergies])
        }

    }
    
    
    
    // MARK:- Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data_dic = pageList[indexPath.row] as! [String: Any]
        let cell = UICollectionViewCell()
        
        if data_dic.keys.contains(constants.titleStr) {
            
            // Configure cell for title
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestTitleCVC", for: indexPath) as? TestTitleCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestTitleCollectionViewCell")
            }
            cell.fillInData(chosenItem: self.chosenItem)
            return cell
            
        } else if data_dic.keys.contains(constants.optionStr) {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.optionList = data_dic[constants.optionStr] as! [orderItem.Option]
            cell.cellType = constants.optionStr
            cell.titleLabel.text = "Choose an Option"
            cell.setUp()
            return cell
            
        } else if data_dic.keys.contains(constants.typeStr) {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            let type = data_dic[constants.typeStr] as! orderItem.type
            cell.optionList = type.choices
            cell.cellType = constants.typeStr
            cell.titleLabel.text = type.name
            cell.setUp()
            return cell
            
        } else if data_dic.keys.contains("Allergies") {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllergyCVC", for: indexPath) as? TestAllergensCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestAllergensCollectionViewCell")
            }
            cell.allergyList = data_dic["Allergies"] as! [String]
            cell.setUp()
            return cell
            
        }
        
        return cell
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let data_dic = pageList[indexPath.row] as! [String: Any]
        var height = CGFloat()
        
        if data_dic.keys.contains(constants.titleStr) {

            height = constants.itemTitleHeight
            
        } else if data_dic.keys.contains(constants.optionStr) {
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }

            //Set height based on table view height
            let optionList = data_dic[constants.optionStr] as! [orderItem.Option]
            height = getCellHeight(optionList: optionList, rowHeight: cell.rowHeight)
            
        } else if data_dic.keys.contains(constants.typeStr) {
            
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            
            let type = data_dic[constants.typeStr] as! orderItem.type
            height = getCellHeight(optionList: type.choices, rowHeight: cell.rowHeight)
        } else if data_dic.keys.contains("Allergies") {
            
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestAllergensCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestAllergensCollectionViewCell")
            }
            
            height = getCellHeight(optionList: currentOrderItem.allergies, rowHeight: cell.rowHeight)
            
        }
        
        //Set Cell size
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func getCellHeight(optionList: [Any]?, rowHeight: CGFloat) -> CGFloat {
        let numRows = (optionList ?? []).count
        let height = rowHeight * CGFloat(numRows) + 60.5
        return height
    }
    

}
