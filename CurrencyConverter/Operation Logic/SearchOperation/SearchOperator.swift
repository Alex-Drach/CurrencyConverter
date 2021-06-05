//
//  SearchOperator.swift
//  CurrencyConverter
//
//  Created by Alex on 05.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// Takes a responsibility to search data in collections.
class SearchOperator: NSObject {
    
    // - MARK: Properties
    weak var delegate: SearchOperatorDelegate?
    private var searchBar: UISearchBar
    private var state: PresentationStates
    private var searchData: [Any]
    
    /// Initializes the SearchOperator components.
    /// - Parameters:
    ///     - search: - UISearchBar - where a user types text.
    ///     - searchData: - Indicates an array of data.
    ///     - state: - Presentation state, according to what the SearchOperator must search data.
    /// - Returns: - A new SearchOperator object to perform defined search actions.
    init(_ search: UISearchBar, searchData: [Any], for state: PresentationStates) {
        self.searchData = searchData
        self.searchBar = search
        self.state = state
        
        super.init()
        searchBar.delegate = self
    }
    
    /// Updates searchData if data is changed.
    /// - Parameters:
    ///     - data: - Array of fresh data.
    public func updateData(from data: [Any]) {
        searchData = data
    }
    
    // - MARK: Private Actions
    
    /// Not filter data if search text is empty!
    private func notFilter() {
        self.delegate?.searchOperator(self, didSearchIn: searchData)
    }
    
    /// Filters search data by name and code.
    /// - Parameters:
    ///     - searchText: - Indicates a search text entered by a user.
    private func dataFilter(by searchText: String) {
        
        /// Filter CoreData saved data.
        if state == .savedContent(.saver) ||  state == .savedContent(.visitor) {
            
            let currencySequence = searchData.filter { (data) -> Bool in
                guard let currency = data as? Item else { return false }
                
                return currency.firstCode.lowercased().contains(searchText.lowercased()) ||
                    currency.secondCode.lowercased().contains(searchText.lowercased())
            }
            delegate?.searchOperator(self, didSearchIn: currencySequence)
            
        }
        /// Filter data created from json.
        else {
            let currencySequence = searchData.filter { (data) -> Bool in
                guard let currency = data as? Currency else { return false }
                
                return currency.code.lowercased().contains(searchText.lowercased()) ||
                    currency.name.lowercased().contains(searchText.lowercased())
            }
            delegate?.searchOperator(self, didSearchIn: currencySequence)
        }
    }
    
}

// - MARK: UISearchBarDelegate
extension SearchOperator: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchText.isEmpty == true ? notFilter() : dataFilter(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
