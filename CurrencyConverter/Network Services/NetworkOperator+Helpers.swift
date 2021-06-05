//
//  NetworkOperator+Helpers.swift
//  CurrencyConverter
//
//  Created by Alex on 05.06.2021.
//

import Foundation

// - MARK: NetworkOperator Helpers
extension NetworkOperator {
    
    /// Makes data serialization.
    /// - Parameters:
    ///     - data: - It's data for been serialized.
    func serializeData(_ data: Data) {
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
    func url() -> URL? {
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
    
    /// Makes multiplication action of entered amount on a got currency rate.
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
