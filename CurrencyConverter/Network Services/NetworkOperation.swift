//
//  NetworkOperation.swift
//  MyCurrency
//
//  Created by Alexandr Drach on 07.05.2021.
//  Copyright © 2021 Alexandr Drach. All rights reserved.

import UIKit

/// Adds a new data task to the Operation queue.
class NetworkOperation: Operation {
    
    /// Operation state.
    enum State: Int {
        case start
        case loading
        case end
    }
    
    // - MARK: Properties
    
    private var task: URLSessionDataTask?
    
    /// Indicates a state, an operation starts from.
    private var operationState: State = .start {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    // overriding states
    override var isReady: Bool { return operationState == .start }
    override var isExecuting: Bool { return operationState == .loading }
    override var isFinished: Bool { return operationState == .end }
  
    
    /// Initializes the NetworkOperation session.
    /// - Parameters:
    ///     - session: - The URL session.
    ///     - URL: - URL adress.
    ///     - completionHandler: - Allows to do actions after session.
    /// - Returns: - A new NetworkOperation session.
    init(session: URLSession, URL: URL, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        super.init()
        
        task = session.dataTask(with: URL, completionHandler: { [weak self] (Data, response, error) in
            
            if let completionHandler = completionHandler { completionHandler(Data, response, error) }
            self?.operationState = .end
        })
    }

    override func start() {
      /// when cancel in the process.
      if isCancelled {
          operationState = .end
          return
      }
      
      /// Loading process
      operationState = .loading
      //print("loading \(self.fetchingTask.originalRequest?.url?.absoluteString ?? "")")
            
      /// to resume the task
        task?.resume()
  }

  override func cancel() {
      super.cancel()
      /// to cancel operation
    task?.cancel()
  }
    
}
