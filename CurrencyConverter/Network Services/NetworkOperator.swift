//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Alex on 07.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// Makes HTTP requests with data tasks.
class NetworkOperator: NSObject {
    
    /// Indicates the NetworkOperator states, according which will be done some actions.
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
    private var sum: String?
    private var pair: String?
    
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
    private func makeRequest(){
        guard let url = url() else { return }
        delegate?.networkOperator(self, didChangeState: .beganConnecting)
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) -> Void in
            guard let self = self else{ return }
            
            if let data = data {
                // work with data
                self.serializeData(data)
            }
            else if let response = response {
                print(String(describing: response.debugDescription))
            }
            else if let error = error {
                self.delegate?.networkOperator(self, didChangeState: .connectionError)
                print("\(error.localizedDescription)!")
            }
        }.resume()
    }
    
}


// - MARK: NetworkOperator Helpers
extension NetworkOperator {
    
    /// Makes data serialization.
    /// - Parameters:
    ///     - data: - It's data for been serialized.
    private func serializeData(_ data: Data) {
        do {
            let neededData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let pair = self.pair,
                  let rate = neededData?[pair] as? Double
            else {
                self.delegate?.networkOperator(self, didChangeState: .infoSupport)
                return
            }
            self.multiply(on: rate)
            self.delegate?.networkOperator(self, didChangeState: .finished)
        }
        catch {
            /// Server died!
            self.delegate?.networkOperator(self, didChangeState: .serverDied)
        }
    }
    
    /// URL for HTTP request.
    /// - Returns: - A url for HTTP request.
    private func url() -> URL? {
        /// Adress to a server responsible for URL.
        let webServer = "https://free.currconv.com/api/v7/convert?q="
        
        /// The server api key:
        /// The key is limited by 100 requests per day, because it's trial version.
        /// Do not use the key, better find a good one somewhere else.
        /// AppStore app version has unlimited key which cannot be shared!.
        let apiKey = "&compact=ultra&apiKey=8a602447b1f1eccc5a49"
        
        guard let keyPair = pair
        else { fatalError("Bed keyPair: \(String(describing: pair))!") }
        
        return URL(string: "\(webServer)\(keyPair)\(apiKey)")
        
    }
    
    /// Makes multiplication action entered amount on a got currency rate.
    /// - Parameters:
    ///     - rate: - It's fresh got currency rate.
    private func multiply(on rate: Double) {
        if let sum = self.sum,
           let amount = Double(sum)
        {
            let result = amount * rate
            self.result = String(format: "%.2f", result)
        }
    }
    
}
