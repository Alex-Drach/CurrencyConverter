//
//  NetworkOperatorDelegate.swift
//  CurrencyConverter
//
//  Created by Alex on 13.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation

/// Delegates the NetworkOperator work.
protocol NetworkOperatorDelegate: class {
    
    /// Tells a client about current network operation state.
    /// - Parameters:
    ///     - networkOperator: - Does networking stuff.
    ///     - didChangeState: - Indicates the networkOperator progress work.
    func networkOperator(_ networkOperator: NetworkOperator, didChangeState state: NetworkOperator.States)
    
}
