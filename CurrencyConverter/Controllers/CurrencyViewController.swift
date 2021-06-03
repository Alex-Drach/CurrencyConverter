//
//  CurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Alex on 26.04.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// Displays different data content in a UITableView.
class CurrencyViewController: UIViewController {
    
    // - MARK: Properties
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var currecnySearch: UISearchBar!
    
    /// Specifies already chosen currency with code.
    var restrictedCode: String?
    /// Indicates the CurrencyViewController presentation state.
    var viewState: PresentationStates?
    /// Operates UITableView actions.
    var tableOperator: TableViewOperator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContent()
        setTableOperator()
    }
    
    // - MARK: Private Actions
    
    /// Setup tableViewOperator delegates.
    private func setTableOperator() {
        if let state = viewState {
        tableOperator = TableViewOperator(currencyTableView, currecnySearch, for: state, with: restrictedCode)
        tableOperator?.delegate = self
        }
    }
    
    /// Set a presenting view controller content according to the PresentationStates.
    private func setPresenterContent(from data: Currency) {
        guard let navigator = presentingViewController as? UINavigationController,
              let presenter = navigator.topViewController as? ConvertViewController
        else { return }
        
        switch viewState {
        case .createContent(.first):
            presenter.chooseFirst.setBackgroundImage(data.flag, for: .normal)
            presenter.firstCode.text = data.code
            presenter.result.text = ""
        case .createContent(.second):
            presenter.chooseSecond.setBackgroundImage(data.flag, for: .normal)
            presenter.secondCode.text = data.code
            presenter.result.text = ""
        default:
            return
        }
        dismiss(animated: true)
    }
    
    /// Adds new data content to display in the View.
    private func addContent() {
        if viewState == .savedContent(.saver) {
            guard let navigator = presentingViewController as? UINavigationController,
                  let presenter = navigator.topViewController as? ConvertViewController,
                  let amount = presenter.amount.text,
                  let result = presenter.result.text,
                  let firstCode = presenter.firstCode.text,
                  let secondCode = presenter.secondCode.text
            else { return }
            
            /// Specifies an item with exactly the same value in CoreData persistence store.
            /// If the item exists, it will be updated, otherwise created.
            let codeGen = "\(firstCode)\(secondCode)\(amount) = \(result)"
            
            if CoreDataOperator.itemNotExists(with: codeGen) {
                let item = Item(context: CoreDataOperator.context)
                item.amount = "\(amount) = \(result)"
                item.date = CurrentDate().toString()
                item.firstCode = firstCode
                item.secondCode = secondCode
                item.id = UUID()
                CoreDataOperator.addData(item)
            }
        }
    }
    
    /// Dismissing the CurrencyViewController.
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// - MARK: TableViewOperatorDelegate
extension CurrencyViewController: TableViewOperatorDelegate {
   
    /// When data selected.
    func tableOperator(_ tableOperator: TableViewOperator, selectedRowAt index: IndexPath) {
        guard let data = tableOperator.data?[index.row] as? Currency else { return }
        setPresenterContent(from: data)
    }
    
    /// When data Updated.
    func tableOperator(_ tableOperator: TableViewOperator, didUpdateData data: [Any]) {
        guard let updatedData = data as? [Item] else { return }
        if updatedData.isEmpty {
            dismiss(animated: true)
        }
        
    }
    
    
    
}
