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
        constructPageList()
    }
    
    func constructPageList() {
        
        //Title
        pageList.append(["Title": chosenItem.name])
        
        //Option
        pageList.append(["Option": chosenItem.options ?? [:]])
        
        //Types
        for (key, value) in chosenItem.types ?? [:] {
            pageList.append(["Type": [key: value]])
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
        
        if data_dic.keys.contains("Title") {
            
            // Configure cell for title
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestTitleCVC", for: indexPath) as? TestTitleCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestTitleCollectionViewCell")
            }
            
            return cell
            
            
        } else if data_dic.keys.contains("Option") {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.titleLabel.text = "Choose an Option"
            cell.options = data_dic["Option"] as! [String : [String : Any]]
            cell.setUp()
            return cell
            
            
        } else if data_dic.keys.contains("Type") {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            
            cell.titleLabel.text = "Choose an Type"
            
            cell.setUp()
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestID", for: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.titleLabel.text = "Extra"
            return cell
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let data_dic = pageList[indexPath.row] as! [String: Any]
        
        if data_dic.keys.contains("Title") {

            //Fill Screen
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        } else if data_dic.keys.contains("Option") {
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }

            //Set height based on table view height
            let numRows = (data_dic["Option"] as! [String: [String: Any]]).count
            let height = cell.rowHeight * CGFloat(numRows) + 36
            return CGSize(width: collectionView.frame.width, height: height)
            
        } else if data_dic.keys.contains("Type") {
            
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            let numRows = (data_dic["Type"] as! [String: [String: Any]]).count
            let height = cell.rowHeight * CGFloat(numRows) + 36
            print(height)

            //Make the values constants
            return CGSize(width: collectionView.frame.width * constants.itemWidthMultiplier, height: height)
            
        } else {
            
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? TestCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            let numRows = (data_dic["Type"] as! [String: [String: Any]]).count
            let height = cell.rowHeight * CGFloat(numRows) + 36
            print(height)

            //Make the values constants
            return CGSize(width: collectionView.frame.width * constants.itemWidthMultiplier, height: height)
            
        }
        
        
    }
    

}
