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
        constructPageList()
        currentOrderItem.createOrderItem(item: chosenItem)
    }
    
    func constructPageList() {
        
        //Title
        pageList.append([constants.titleStr: chosenItem.name])
        
        //Option
        pageList.append([constants.optionStr: chosenItem.options ?? [:]])
        
        //Types
        for (key, value) in chosenItem.types ?? [:] {
            pageList.append([constants.typeStr: [key: value]])
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
            
            self.fillOutTitleCell(cell: cell, data: data_dic)
            return cell
            
        } else if data_dic.keys.contains(constants.optionStr) {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.cellType = constants.optionStr
            cell.titleLabel.text = "Choose an Option"
            cell.optionDic = data_dic[constants.optionStr] as! [String : [String : Any]]
            cell.setUp()
            return cell
            
        } else if data_dic.keys.contains(constants.typeStr) {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.cellType = constants.typeStr
            let type_dic = data_dic[constants.typeStr] as! [String : [String : Any]]
            cell.titleLabel.text = type_dic.first?.key
            cell.optionDic = type_dic.first?.value ?? [:]
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
            let optionDic = data_dic[constants.optionStr] as! [String: [String: Any]]
            height = getCellHeight(cellDic: optionDic, rowHeight: cell.rowHeight)
            
        } else if data_dic.keys.contains(constants.typeStr) {
            
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            
            let type_dic = data_dic[constants.typeStr] as! [String : [String : Any]]
            height = getCellHeight(cellDic: type_dic.first?.value, rowHeight: cell.rowHeight)
            
        }
        
        //Set Cell size
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func getCellHeight(cellDic: [String: Any]?, rowHeight: CGFloat) -> CGFloat {
        let numRows = (cellDic ?? [:]).count
        let height = rowHeight * CGFloat(numRows) + 60.5
        return height
    }
    
    func fillOutTitleCell(cell: TestTitleCollectionViewCell, data: [String: Any]) {
        
        
        cell.titleLabel.text = chosenItem.name
        cell.descriptionLabel.text = chosenItem.desc
        cell.allergenLabel.text = cell.makeAllergenLabel(allergenList: chosenItem.allergens)
        
        //Get the item image from firebase
        cell.imageView.LoadImageUsingCache(ImageRef: chosenItem.getImageRef()) { (isFound) in
            if !isFound {
                //Do something if the image could not be found
                print("not found")
            }
        }
    }
    

}
