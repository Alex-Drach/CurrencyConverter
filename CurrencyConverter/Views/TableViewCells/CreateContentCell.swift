//
//  CreateContentCell.swift
//  CurrencyConverter
//
//  Created by Alex Drach on 30.04.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// The cell presents created content in UITableView.
class CreateContentCell: UITableViewCell {
    
    // - MARK: Properties
    
    @IBOutlet weak private var currencyFlag: UIImageView!
    @IBOutlet weak private var currencyFullName: UILabel!
    @IBOutlet weak private var currencyCode: UILabel!
    
    /// View for selected cell in UITableView.
    private var selectedView: UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    public var code: String {
        return currencyCode.text ?? "noCode"
    }
    public var name: String {
        return currencyFullName.text ?? "noName"
    }
    
    // - MARK: Actions
    
    /// Set cell view from a currency content.
    /// - Parameters:
    ///     - content: - Indicates a new Currency object.
    public func setView(from content: Currency) {
        currencyFlag.image = content.flag
        currencyFullName.text = content.name
        currencyCode.text = content.code
        self.selectedBackgroundView = selectedView
    }
    
}
