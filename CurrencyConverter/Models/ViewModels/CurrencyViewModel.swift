//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Alex on 23.04.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit
import CoreData

/// Provides a view different data to display.
final class CurrencyViewModel {
    
    // - MARK: Properties
    
    /// Indicates a view content presentation state.
    private var state: PresentationStates
    
    /// Contains some kind of data according to presentation state.
    var data: [Any]? {
        if state == .savedContent(.saver) || state == .savedContent(.visitor) {
            return CoreDataOperator.getData()
        }
        else {
            return createDataContent()
        }
    }
    
    // - MARK: Initialization
    
    /// Initializes a new CurrencyViewModel.
    /// - Parameters:
    ///        - state: - Indicates what data will be passed from the CurrencyViewModel.
    ///   - Returns: - A new ViewModel for displaying and managing a currency list.
    init(with state: PresentationStates) {
        self.state = state
    }
    
    // - MARK: Actions
    
    /// Deletes data from the CoreData store.
    /// - Parameters:
    ///     - index: - Indicates an index of the deleting Item.
    func deleteData(at index: Int) {
        if let item = data?[index] as? Item {
            CoreDataOperator.delete(item)
        }
    }
    
    // - MARK: Private Actions
    
    /// Creates a view content from decoded data.
    ///  - Returns: - Sorted array of currency data content.
    private func createDataContent() -> [Currency] {
        
        let currencyDictionary: [String: String] = decodeData(from: "Currencies.json")
        
        var currencyData: [Currency] = []
        
        if !currencyDictionary.isEmpty {
            for data in currencyDictionary {
                let currency = Currency(name: data.value, code: data.key)
                currencyData.append(currency)
            }
        }
        return currencyData.sorted()
    }
    
    /// Decodes data from a json file.
    /// - Parameters:
    ///     - fileName: - It's a String presentation of the file, like: "FileName.json".
    ///  - Returns: - Decoded data of Generic `Type`.
    private func decodeData<Type: Decodable>(from fileName: String) -> Type {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil)
        else {
            fatalError("Couldn't find \(fileName) in main bundle!")
        }
        do {
            data = try Data(contentsOf: file)
        }
        catch {
            fatalError("Couldn't read from \(file) in main bundle:\n\(error)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Type.self, from: data)
        }
        catch {
            fatalError("Couldn't decode \(fileName) as \(Type.self):\n\(error) ")
        }
    }
    
}
