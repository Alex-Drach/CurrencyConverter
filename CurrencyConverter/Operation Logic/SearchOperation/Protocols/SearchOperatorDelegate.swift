//
//  SearchOperatorDelegate.swift
//  CurrencyConverter
//
//  Created by Alex on 06.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation


/// Delegates the SearchOperator actions.
protocol SearchOperatorDelegate: class {
    
    /// Tells about: a data is changed in a sequence, by a searching result.
    /// - Parameters:
    ///     - searchOperator: - Does searching stuff.
    ///     - sequence: - Indicates an array of data where the searchOperator searched in.
    func searchOperator(_ searchOperator: SearchOperator, didSearchIn sequence: [Any])
    
    
}

