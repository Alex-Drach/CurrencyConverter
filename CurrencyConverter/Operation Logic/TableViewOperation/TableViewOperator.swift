//
//  TableViewOperator.swift
//  CurrencyConverter
//
//  Created by Alex on 07.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation
import UIKit

/// Operates UITableView Actions.
class TableViewOperator: NSObject {
    
    // - MARK: Properties
    private let numberOfSections: Int = 1
    private var tableView: UITableView
    private var state: PresentationStates
    private var search: UISearchBar
    weak var delegate: TableViewOperatorDelegate?
    
    /// Presents already chosen code value.
    var restrictedCode: String?
    var viewModel: CurrencyViewModel?
    var searchOperator: SearchOperator?
    var data: [Any]?
    let deviceState = UIDevice.current.userInterfaceIdiom
    
    /// Initializes TableViewOerator components.
    /// - Parameters:
    ///     - tableView: - UITableView - where data will be displayed.
    ///     - search: - UISearchBar - where a user types text.
    ///     - state: - Indicates what kind of data will be presented.
    ///     - code: - Indicates already chosen currency code.
    /// - Returns: - A new TableViewOperator object to perform defined UITableView actions.
    init(_ tableView: UITableView, _ search: UISearchBar, for state: PresentationStates, with code: String?) {
        self.state = state
        self.restrictedCode = code
        self.tableView = tableView
        self.search = search
        //------------//
        super.init()
        //-----------//
        self.setData()
        self.setTableDelegates()
        self.setSearch()
    }
    
    // - MARK: Private Actions
    /// Set viewModel & get data for UITableView presentation.
    private func setData() {
        viewModel = CurrencyViewModel(with: state)
        data = viewModel?.data
    }
    /// Set UITableView delegates.
    private func setTableDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    /// Set search operator.
    private func setSearch() {
        guard let searchData = viewModel?.data else { return }
        searchOperator = SearchOperator(search, searchData: searchData , for: state)
        searchOperator?.delegate = self
    }
    
    /// Delete cell action target.
    @objc private func delete(sender: UIButton) {
        if let cell = sender.superview?.superview as? SavedContentCell,
           let indexPath = tableView.indexPath(for: cell)
        {
            viewModel?.deleteData(at: indexPath.row)
            data?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshData()
        }
    }
    /// Refresh data
    private func refreshData() {
        tableView.reloadData()
        guard let data = self.data else { return }
        delegate?.tableOperator(self, didUpdateData: data)
        searchOperator?.updateData(from: data)
    }
    
    /// Returns cell for row at indexPath.
    private func cell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        
        case .createContent(.first), .createContent(.second):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateContentCell", for: indexPath) as? CreateContentCell,
                  let data = data?[indexPath.row] as? Currency
            else {
                fatalError("Couldn't find indexPath: \(indexPath)!")
            }
            cell.setView(from: data)
            return cell
            
        case .savedContent(.saver), .savedContent(.visitor):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedContentCell", for: indexPath) as? SavedContentCell,
                  let data = data?[indexPath.row] as? Item
            else {
                fatalError("Couldn't find indexPath: \(indexPath)!")
            }
            cell.delete.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
            cell.setView(from: data)
            return cell
        }
    }
    
}
// - MARK: UITableViewDelegate && Source ))
extension TableViewOperator: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CreateContentCell else { return }
        
        if state == .createContent(.first) && restrictedCode != cell.code {
            self.delegate?.tableOperator(self, selectedRowAt: indexPath)
        }
        else if state == .createContent(.second) && restrictedCode != cell.code {
            self.delegate?.tableOperator(self, selectedRowAt: indexPath)
        }
        else if restrictedCode == cell.code {
            cell.shake()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = deviceState == .pad ? 120 : 80
        return height
    }
    
}
// - MARK: SearchOperatorDelegate
extension TableViewOperator: SearchOperatorDelegate {
    
    func searchOperator(_ searchOperator: SearchOperator, didSearchIn sequence: [Any]) {
        DispatchQueue.main.async { [self] in
        data = sequence
        tableView.reloadData()
        }
    }
}
