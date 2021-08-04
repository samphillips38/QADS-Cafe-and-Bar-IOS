//
//  ItemDetailViewController.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 12/06/2021.
//

import UIKit

private let titleReuseID = "TitleCVC"
private let optionsReuseID = "OptionsCVC"
private let allergyReuseID = "AllergyCVC"
private let checkoutReuseID = "CheckoutCVC"

class ItemDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var chosenItem = Item()
    var currentOrderItem = orderItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        currentOrderItem.createOrderItem(item: chosenItem) {
            self.collectionView.reloadData()
        }
        
        // Layout Button
        cancelButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        cancelButton.layer.cornerRadius = 5
    }
    
    func getCellType(indexPath: IndexPath) -> Int {
        let typeNum = currentOrderItem.types.count
        if indexPath.row == 0 {
            return constants.titleCell
        } else if indexPath.row == 1 {
            return constants.optionCell
        } else if 0 <= indexPath.row-2 && indexPath.row-2 < typeNum {
            return constants.typeCell
        } else if indexPath.row == typeNum + 2 {
            return constants.allergyCell
        } else {
            return constants.checkoutCell
        }
    }
    
    
    // MARK:- Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Add one for title, one for options, one for allergies, one for checkout
        return currentOrderItem.types.count + 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        if getCellType(indexPath: indexPath) == constants.titleCell { // This is the title cell
            
            // Configure cell for title
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleReuseID, for: indexPath) as? ItemTitleCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of ItemTitleCollectionViewCell")
            }
            cell.fillInData(chosenItem: self.chosenItem)
            return cell
            
        } else if getCellType(indexPath: indexPath) == constants.optionCell { // This is the Options cell
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: optionsReuseID, for: indexPath) as? OptionsCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of TestCollectionViewCell")
            }
            cell.cellType = constants.optionCell
            cell.index = indexPath
            cell.currentOrderItem = currentOrderItem
            cell.onCellTapped = optionTapped
            cell.setUp()
            return cell
            
        } else if getCellType(indexPath: indexPath) == constants.typeCell { // This is a Type
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: optionsReuseID, for: indexPath) as? OptionsCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of OptionsCollectionViewCell")
            }
            cell.cellType = constants.typeCell
            cell.index = indexPath
            cell.currentOrderItem = currentOrderItem
            cell.onCellTapped = optionTapped
            cell.setUp()
            return cell
            
        } else if getCellType(indexPath: indexPath) == constants.allergyCell { // This is an Allergy Cell
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: allergyReuseID, for: indexPath) as? AllergensCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of AllergensCollectionViewCell")
            }
            cell.presentVC = {(VC: UIViewController) -> Void in
                self.present(VC, animated: true, completion: nil)
            }
            cell.currentOrderItem = currentOrderItem
            cell.setUp()
            return cell
            
        } else if getCellType(indexPath: indexPath) == constants.checkoutCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: checkoutReuseID, for: indexPath) as? CheckoutCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of CheckoutCollectionViewCell")
            }
            cell.currentOrderItem = currentOrderItem
            cell.inStock = chosenItem.stock ?? false
            cell.dismiss = {
                self.dismiss(animated: true, completion: nil)
            }
            cell.setUp()
            return cell
        }
        
        return cell
        

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height = CGFloat()

        if getCellType(indexPath: indexPath) == constants.titleCell {
            let descriptionHeight = estimateTextFrame(text: chosenItem.desc ?? "", width: collectionView.frame.width - CGFloat(40)).height
            let temp = ItemTitleCollectionViewCell()
            let allergenInfoHeight = estimateTextFrame(text: temp.makeAllergenLabel(allergenList: chosenItem.allergens), width: collectionView.frame.width - CGFloat(40)).height
            
            height = constants.itemTitlePadding + descriptionHeight + allergenInfoHeight

        } else if getCellType(indexPath: indexPath) == constants.optionCell {
            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? OptionsCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of OptionsCollectionViewCell")
            }

            //Set height based on table view height
            let optionList = currentOrderItem.options
            height = getCellHeight(optionList: optionList, rowHeight: cell.rowHeight, offset: constants.optionTVOffset)

        } else if getCellType(indexPath: indexPath) == constants.typeCell {

            guard let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath) as? OptionsCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of OptionsCollectionViewCell")
            }

            let type = currentOrderItem.types[indexPath.row - 2]
            height = getCellHeight(optionList: type.choices, rowHeight: cell.rowHeight, offset: constants.optionTVOffset)
        } else if getCellType(indexPath: indexPath) == constants.allergyCell {
            height = constants.allergyHeight
        } else if getCellType(indexPath: indexPath) == constants.checkoutCell {
            height = constants.itemCheckoutHeight
        }

        //Set Cell size
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func getCellHeight(optionList: [Any]?, rowHeight: CGFloat, offset: CGFloat) -> CGFloat {
        let numRows = (optionList ?? []).count
        let height = rowHeight * CGFloat(numRows)
        return height + offset
    }
    
    func estimateTextFrame(text: String, width: CGFloat, size: Int = 16, weight: UIFont.Weight = UIFont.Weight.light) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 10000
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: weight)]

        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }

    func optionTapped() {
        // Get Checkout cell and refresh contents to update price
        let n = collectionView.numberOfItems(inSection: 0) - 1
        guard let cell = collectionView.cellForItem(at: IndexPath(item: n, section: 0)) as? CheckoutCollectionViewCell else {
            print("Could not refresh Checkout cell - Cell not found")
            return
        }
        cell.setUp()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
