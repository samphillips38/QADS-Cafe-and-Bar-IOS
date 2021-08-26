//
//  Basket2ViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/05/2021.
//

import UIKit

private let emptyBasketIdentifier = "emptyBasketCVC"
private let reuseIdentifier = "OrderItemCVC"
private let tableNumberIdentifier = "TableNumberCVC"
private let orderNotesIdentifier = "OrderNotesCVC"
private let detailsReuseIdentifier = "DetailsCVC"

class BasketViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, orderItemsDelegate, UITextFieldDelegate {
    
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
    }
    
    func setPrice() {
        let price = currentUser.barOrder.price + currentUser.cafeOrder.price
        totalLabel.text = "£" + String(format: "%.2f", price)
    }

    func layout() {

        //Stack View Layout for button
        orderStackView.layer.cornerRadius = orderStackView.frame.height/2
        setPrice()
    }
    
    //MARK: -Collection view
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return max(1, currentUser.cafeOrder.items.count + currentUser.barOrder.items.count)
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 { // This is in the items section
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
            
            cell.descriptionLabel.isHidden = !(expandedItems[indexPath.row] ?? false)
            cell.infoButton.isHidden = expandedItems[indexPath.row] ?? false
            
            return cell
        } else if indexPath.row == 0 { // Set up details cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsReuseIdentifier, for: indexPath) as? DetailsCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of DetailsCollectionViewCell")
            }
            return cell
        } else if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tableNumberIdentifier, for: indexPath) as? TableNumberCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TableNumberCollectionViewCell")
            }
            cell.TableNumberTextField.delegate = self
            cell.TableNumberTextField.text = currentUser.cafeOrder.table_number
            return cell
        } else if indexPath.row == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: orderNotesIdentifier, for: indexPath) as? OrderNotesCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of OrderNotesCollectionViewCell")
            }
            cell.orderNotesTextField.delegate = self
            cell.orderNotesTextField.text = currentUser.cafeOrder.table_number
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Items section
            if expandedItems[indexPath.row]==nil {
                expandedItems[indexPath.row] = true
            } else {
                expandedItems[indexPath.row]?.toggle()
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 { // Items section
            //Handle Empty Basket
            if currentUser.cafeOrder.items.count + currentUser.barOrder.items.count == 0 {
                return CGSize(width: collectionView.frame.width, height: constants.basketHeight)
            }
            
            if expandedItems[indexPath.row] ?? false { // Cell is expanded
                
                return getExpandedSize(for: indexPath)
            } else {
                //Cell is collapsed
                return CGSize(width: collectionView.frame.width, height: constants.basketHeight)
            }
        } else if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: constants.detailsHeight)
            
        } else if indexPath.row == 1 {
            return CGSize(width: collectionView.frame.width, height: constants.tableNumberHeight)
            
        } else if indexPath.row == 2 {
            return CGSize(width: collectionView.frame.width, height: constants.tableNumberHeight)
            
        } else { // Fill this in later - for details, notes and table no.
            return CGSize(width: collectionView.frame.width, height: constants.tableNumberHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(0)
        } else {
            return CGFloat(40)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    //MARK: -Functions
    
    func getExpandedSize(for indexPath: IndexPath) -> CGSize {
        
        let temp = OrderItemsCollectionViewCell()
        let detailsHeight = estimateTextFrame(text: temp.getDetails(item: currentUser.getItemAt(index: indexPath.row)), width: collectionView.frame.width - CGFloat(20), font: UIFont.systemFont(ofSize: 15)).height
        
        //Cell is expanded
        return CGSize(width: collectionView.frame.width, height: detailsHeight + CGFloat(70))
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let TableNumberCell = collectionView.cellForItem(at: IndexPath(row: 1, section: 1)) as! TableNumberCollectionViewCell
        
        if textField == TableNumberCell.TableNumberTextField { // Sent from table notes
            let newPosition = TableNumberCell.frame.origin.y + textField.frame.origin.y - collectionView.frame.height / 2

            collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: newPosition), animated: true)
        } else {
            let orderNotesCell = collectionView.cellForItem(at: IndexPath(row: 2, section: 1)) as! OrderNotesCollectionViewCell
            
            let newPosition = orderNotesCell.frame.origin.y + textField.frame.origin.y - collectionView.frame.height / 2

            collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: newPosition), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let TableNumberCell = collectionView.cellForItem(at: IndexPath(row: 1, section: 1)) as! TableNumberCollectionViewCell
        
        if textField == TableNumberCell.TableNumberTextField {
            currentUser.cafeOrder.table_number = textField.text
            currentUser.barOrder.table_number = textField.text
        } else {
            currentUser.cafeOrder.note = textField.text
            currentUser.barOrder.note = textField.text
        }
    }
    
    //MARK: -Button actions
    
    @objc func orderTapped(_ sender: UITapGestureRecognizer? = nil) {
        
        //Show warning message about Checking out
        let message = "Before you checkout, have you topped up your uPay?"
        
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            //Checkout order once confirmed
            currentUser.checkoutAll {
                
                //Show confirmation screen (fullscreen)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let confirmationVC = storyBoard.instantiateViewController(withIdentifier: "OrderConfirmationVC") as! OrderConfirmationViewController
                confirmationVC.modalPresentationStyle = .fullScreen
                
                self.present(confirmationVC, animated: true) {
                    
                    //Refresh the table data
                    self.collectionView.reloadData()
                    self.layout()
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            //Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
