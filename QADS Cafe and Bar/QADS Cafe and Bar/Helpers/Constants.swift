//
//  Constants.swift
//  QADS Cafe and Bar
//
//  Created by Sam Phillips on 05/12/2020.
//

import UIKit

struct constants {
    
    // Layout constants
    static let categoryWidthMultiplier = CGFloat(0.93)
    static let categoryHeightMultiplier = CGFloat(0.65)
    
    static let itemWidthMultiplier = CGFloat(0.95)
    static let itemHeightMultiplier = CGFloat(0.3)
    
    static let basketHeight = CGFloat(100)
    static let detailsHeight = CGFloat(190)
    static let tableNumberHeight = CGFloat(150)
    
    static let itemTitlePadding = CGFloat(349)
    static let optionTVOffset = CGFloat(96)
    static let allergyPadding = CGFloat(140)
    static let itemCheckoutHeight = CGFloat(150)
    
    static let queensGreen = UIColor(red: 0.30, green: 0.69, blue: 0.31, alpha: 1.00)
    
    
    // For string values
    static let titleStr = "Title"
    static let optionStr = "Option"
    static let typeStr = "Type"
    
    static let cafe = "cafe"
    static let bar = "bar"
    static let buttery = "buttery"
    
    // Cell types
    static let optionCell = 0
    static let allergyCell = 1
    static let typeCell = 2
    static let titleCell = 3
    static let checkoutCell = 4
}

func estimateTextFrame(text: String, width: CGFloat, font: UIFont) -> CGRect {
    //we make the height arbitrarily large so we don't undershoot height in calculation
    let height: CGFloat = 10000
    let size = CGSize(width: width, height: height)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let attributes = [NSAttributedString.Key.font: font]

    return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
}

