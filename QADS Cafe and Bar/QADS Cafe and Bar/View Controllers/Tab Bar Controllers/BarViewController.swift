//
//  BarViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 06/02/2021.
//

import UIKit
import FirebaseFirestore

private let reuseIdentifier = "BarCategoryCell"

class BarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var isOpenView: UIView!
    @IBOutlet weak var isOpenConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryList = CategoryList()
    var isOpen = true
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp()
    }
    

    func setUp() {
        
        //Set up collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Set open status
        setOpenStatus {
            //Do something depending on outcome
        }

        //Set up the xib file for the event cells
        let nib = UINib(nibName: "CategoriesCollectionViewCell",bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        //Get all the active categories
        categoryList.getBarCategories {
            self.collectionView.reloadData()
        }
        
        
        //adding the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        
        //send behind cells but in front of background
        refreshControl.layer.zPosition = 0
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }
    
    //refresh control
    @objc func refreshData() {
        //Refresh data
        setOpenStatus {
            self.refreshControl.endRefreshing()
        }
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
        db.collection("locations").whereField("name", isEqualTo: "Bar").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting categories: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let doc = document.data() as [String : Any]
                        self.isOpen = (doc["open"] as? Bool) ?? true
                        
                        //Animate banner
                        self.animateOpenBanner()
                    }
                }
                Completion()
        }
    }
    
    func animateOpenBanner() {
        if isOpen {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.isOpenConstraint.constant = -20
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.isOpenConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func shakeBanner() {
        //Banner will shake
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: isOpenView.center.x - 5, y: isOpenView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: isOpenView.center.x + 5, y: isOpenView.center.y))
        isOpenView.layer.add(animation, forKey: "position")
    }

    // MARK:- UICollectionViewDataSource

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell...
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoriesCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CategoriesCollectionViewCell")
        }
        
        //set cell above refresh control
        cell.layer.zPosition = 1
        
        cell.fillInWithCategory(category: categoryList.categories[indexPath.row]) {
            
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //Make the values constants
        return CGSize(width: collectionView.frame.width * constants.categoryWidthMultiplier, height: collectionView.frame.width * constants.categoryHeightMultiplier)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //If closed do nothing
        if !self.isOpen {
            shakeBanner()
            return
        }
        
        //Go to Item VC
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ItemVC = storyBoard.instantiateViewController(withIdentifier: "ItemVC") as! ItemsViewController
        
        ItemVC.location = "Bar"
        ItemVC.category = categoryList.categories[indexPath.row].name ?? ""
        
        self.navigationController?.pushViewController(ItemVC, animated: true)
        
    }

}
