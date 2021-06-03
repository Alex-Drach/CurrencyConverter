//
//  TableViewOperatorDelegate.swift
//  CurrencyConverter
//
//  Created by Alex on 07.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation

/// Delegates the TableViewOperator actions.
protocol TableViewOperatorDelegate: class {
    
    /// Tells about: data is selected in a row with a specified index.
    /// - Parameters:
    ///     - tableOperator: - Does operation actions in UITableView.
    ///     - index: - Indicates an IndexPath of selected row in UITableView.
    func tableOperator(_ tableOperator: TableViewOperator, selectedRowAt index: IndexPath)
    
    /// Tells about: data is updated.
    /// - Parameters:
    ///     - tableOperator: - Does operation actions in UITableView.
    ///     - data: - Indicates an array with updated data.
    func tableOperator(_ tableOperator: TableViewOperator, didUpdateData data: [Any])
    
}
