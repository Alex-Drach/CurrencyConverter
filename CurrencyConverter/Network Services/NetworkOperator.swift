//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Alex on 07.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit
import Foundation

/// Operates networking processes.
class NetworkOperator: NSObject {
    
    /// Indicates the NetworkOperator states, according which will be done actions.
    enum States: Equatable {
        case beganConnecting
        case connectionError
        case infoSupport
        case serverDied
        case finished
    }
    
    // - MARK: Properties
    
    weak var delegate: NetworkOperatorDelegate?
    var result: String?
    var sum: String?
    var pair: String?
    
    // - MARK: Actions
    
    /// Gets needed data to make a HTTP request.
    /// - Parameters:
    ///     - sum: - It's currency amount a user converts from.
    ///     - from: - It's code name of a currency a user converts from.
    ///     - to: - It's code name of a currency a user converts to.
    public func getData(sum: String, from: String, to: String) {
        self.pair = "\(from)_\(to)"
        self.sum = sum
        self.makeRequest()
    }
    
    // - MARK: Private Actions
    
    /// Makes HTTP request.
    private func makeRequest() {
        // to make request in a queue
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        guard let url = url() else { return }
        
        delegate?.networkOperator(self, didChangeState: .beganConnecting)
        
        let operation = NetworkOperation(session: URLSession.shared, URL: url, completionHandler: { [weak self] (data, response, error) in
            guard let self = self else{return}
            
            if let data = data {
                // work with data
                self.serializeData(data)
            }
            else if let response = response {
                // work with responce
                print(String(describing: response.debugDescription))
            }
            else if let error = error {
                // work with error
                self.delegate?.networkOperator(self, didChangeState: .connectionError)
                print("\(error.localizedDescription)!")
            }
        })
        queue.addOperation(operation)
        
    }
    
}

