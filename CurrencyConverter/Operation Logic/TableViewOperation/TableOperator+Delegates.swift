//
//  TableOperator+Delegates.swift
//  CurrencyConverter
//
//  Created by Alex on 05.06.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit


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
