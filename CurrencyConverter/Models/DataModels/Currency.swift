//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Alex on 23.04.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation
import UIKit

/// It's what a currency consist from.
struct Currency: Decodable {
    
    /// It's currency full name like: "US Dollar" or "British Pound"
    let name: String
    
    /// It's currency code like: "USD" or "GBP"
    let code: String
    
    /// Currency flag - presents where the currency is from.
   weak var flag: UIImage? {
        guard let image = UIImage(named: code) else {
            return nil
            ///fatalError("Couldn't find the currency flag named: \(code)!")
        }
            return image
    }
    
}

// - MARK: Comparable
extension Currency: Comparable {
    
    /// Hash comparing helps automatically to sort an unsorted currency array.
    static func < (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.name < rhs.name
    }
}
