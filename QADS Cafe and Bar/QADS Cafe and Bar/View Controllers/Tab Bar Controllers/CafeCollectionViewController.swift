//
//  CafeCollectionViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit
import FirebaseFirestore

private let reuseIdentifier = "CafeCategoryCell"

class CafeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var categoryList = CategoryList()
    var isOpen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set open status
        setOpenStatus {
            //Do something depending on outcome
        }

        //Set up the xib file for the event cells
        let nib = UINib(nibName: "CategoriesCollectionViewCell",bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        //Get all the active categories
        categoryList.getCafeCategories {
            self.collectionView.reloadData()
        }
        
        //set title image possibly change later?
//        setTitleImage()
     
    }
    
    func setTitleImage() { //not implemented right now
        let titleView = UIImageView(image: UIImage(named: "QueensCrest"))
        titleView.contentMode = .scaleAspectFit
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
            
        if let navC = self.navigationController{
            navC.navigationBar.addSubview(titleView)
            titleView.centerXAnchor.constraint(equalTo: navC.navigationBar.centerXAnchor).isActive = true
            titleView.centerYAnchor.constraint(equalTo: navC.navigationBar.centerYAnchor, constant: 0).isActive = true
            titleView.widthAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.2).isActive = true
            titleView.heightAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.088).isActive = true
        }
    }
    
    
    func setOpenStatus(Completion: @escaping () -> Void) {
        
        //Load Firestore Database
        let db = Firestore.firestore()
        
        //Get all active Events
        db.collection("locations").whereField("name", isEqualTo: "cafe").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting categories: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let doc = document.data() as [String : Any]
                        self.isOpen = (doc["open"] as? Bool) ?? true
                    }
                }
                Completion()
        }
    }
    
    

    // MARK:- UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell...
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoriesCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CategoriesCollectionViewCell")
        }
        
        cell.fillInWithCategory(category: categoryList.categories[indexPath.row]) {
            
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //Make the values constants
        return CGSize(width: collectionView.frame.width * constants.categoryWidthMultiplier, height: collectionView.frame.width * constants.categoryHeightMultiplier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: ", categoryList.categories[indexPath.row])
        
        //Go to Item VC
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ItemVC = storyBoard.instantiateViewController(withIdentifier: "ItemVC") as! ItemsViewController
        
        ItemVC.location = "Cafe"
        ItemVC.category = categoryList.categories[indexPath.row].name ?? ""
        
        self.navigationController?.pushViewController(ItemVC, animated: true)
        
    }
}
