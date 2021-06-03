//
//  CurrentDate.swift
//  CurrencyConverter
//
//  Created by Alex on 16.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation

/// Creates device current date and time.
class CurrentDate {
    
    //MARK: - Properties
    private let date = Date()
    private let calendar = Calendar.current
    private let formatter = DateComponentsFormatter()
    private let dateFormatter = DateFormatter()
    
    //MARK: - Actions
    
    /// Formats current date into string.
    /// - Returns: - String representation of current date.
    public func toString() -> String {
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy/MM/dd h:mm:ss a"
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        guard let formattedDate = formatter.calendar?.date(from: components) else { return "noDate"}
        let currentDate = dateFormatter.string(from: formattedDate)
        return currentDate
    }
    
}
