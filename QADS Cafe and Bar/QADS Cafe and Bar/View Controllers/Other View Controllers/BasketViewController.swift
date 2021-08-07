//
//  Basket2ViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/05/2021.
//

import UIKit

private let emptyBasketIdentifier = "emptyBasketCVC"
private let reuseIdentifier = "OrderItemCVC"
private let footerID = "DetailsFooter"

class BasketViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, orderItemsDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderStackView: UIStackView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var expandedItems: [Int: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up Collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //set action for stack view
        orderStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(orderTapped(_:))))
        orderStackView.isUserInteractionEnabled = true
        
        layout()
        setPrice()
    }
    
    func setPrice() {
        let price = currentUser.barOrder.price + currentUser.cafeOrder.price
        totalLabel.text = "£" + String(format: "%.2f", price)
    }

    func layout() {

        //Stack View Layout for button
        orderStackView.layer.cornerRadius = orderStackView.frame.height/2
    }
    
    //MARK: -Collection view
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(1, currentUser.cafeOrder.items.count + currentUser.barOrder.items.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Handle Empty Basket
        if currentUser.cafeOrder.items.count + currentUser.barOrder.items.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyBasketIdentifier, for: indexPath)
            return cell
        }
        
        //Basket with items
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? OrderItemsCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of OrderItemsCollectionViewCell")
        }
        cell.fillInData(item: currentUser.getItemAt(index: indexPath.row))
        
        //set delegate and index
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if expandedItems[indexPath.row]==nil {
            expandedItems[indexPath.row] = true
        } else {
            expandedItems[indexPath.row]?.toggle()
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath)
        return headerView
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Handle Empty Basket
        if currentUser.cafeOrder.items.count + currentUser.barOrder.items.count == 0 {
            return CGSize(width: collectionView.frame.width * constants.basketItemWidthMultiplier, height: constants.basketHeight)
        }
        
        if expandedItems[indexPath.row] ?? false {
            let temp = OrderItemsCollectionViewCell()
            let detailsHeight = estimateTextFrame(text: temp.getDetails(item: currentUser.getItemAt(index: indexPath.row)), width: collectionView.frame.width - CGFloat(20), font: UIFont.systemFont(ofSize: 15)).height
            
            //Cell is expanded
            return CGSize(width: collectionView.frame.width * constants.basketItemWidthMultiplier, height: constants.basketHeight + detailsHeight + CGFloat(30))
        } else {
            //Cell is collapsed
            return CGSize(width: collectionView.frame.width * constants.basketItemWidthMultiplier, height: constants.basketHeight)
        }
    }

    func deleteItemTapped(index: Int) {
        
        //Show warning message about deleting the item
        let message = "Are you sure you want to delete this item?"
        
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            
            //delete item
            currentUser.removeItemAt(index: index)
            self.deleteExpandedElement(at: index)
            self.setPrice()
            self.collectionView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteExpandedElement(at index: Int) {
        if index == 0 {
            expandedItems.removeValue(forKey: index)
            return
        }
        var maxKey = 0
        for (key, _) in expandedItems {
            if key > index {
                expandedItems[key-1] = expandedItems[key]
            }
            maxKey = key
        }
        expandedItems.removeValue(forKey: maxKey)
    }
    
    
    //MARK: -Text Field
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        currentUser.cafeOrder.note = textField.text
//        currentUser.barOrder.note = textField.text
//    }
    
    
    //MARK: -Button actions
    
    @objc func orderTapped(_ sender: UITapGestureRecognizer? = nil) {
        
        //Show warning message about Checking out
        let message = "Before you checkout, have you topped up your uPay?"
        
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            //Checkout order once confirmed
            currentUser.checkout {
                
                //Show confirmation screen (fullscreen)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let confirmationVC = storyBoard.instantiateViewController(withIdentifier: "OrderConfirmationVC") as! OrderConfirmationViewController
                confirmationVC.modalPresentationStyle = .fullScreen
                
                self.present(confirmationVC, animated: true) {
                    
                    //Refresh the table data
                    self.collectionView.reloadData()
                    self.layout()
                    self.setPrice()
//                    self.orderNotesTextField.text = ""
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            //Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
