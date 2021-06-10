//
//  SavedContentCell.swift
//  CurrencyConverter
//
//  Created by Alex on 30.04.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// The cell presents saved data content in UITableView.
class SavedContentCell: UITableViewCell {
    
    // - MARK: Properties
    
    @IBOutlet weak var firstCurrencyFlag: UIImageView!
    @IBOutlet weak var secondCurrencyFlag: UIImageView!
    @IBOutlet weak var firstCurrencyCode: UILabel!
    @IBOutlet weak var secondCurrencyCode: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var convertedAmount: UILabel!
    
    // - MARK: Actions
    
    /// Sets cell view from a savedContent.
    /// - Parameters:
    ///     - savedContent: - Indicates CoreData saved Item.
    func setView(from savedContent: Item) {
        firstCurrencyFlag.image = UIImage(named: savedContent.firstCode)
        secondCurrencyFlag.image = UIImage(named: savedContent.secondCode)
        firstCurrencyCode.text = savedContent.firstCode
        secondCurrencyCode.text = savedContent.secondCode
        date.text = savedContent.date
        convertedAmount.text = savedContent.amount
    }
    
}
