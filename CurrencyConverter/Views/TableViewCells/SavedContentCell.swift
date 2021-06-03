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
    
    /// Set cell view from a savedContent.
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
    
    /// When selcted...
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        /// The cell view selection style.
        self.selectedBackgroundView?.backgroundColor = selected != !selected ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.4411386986) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }

}
