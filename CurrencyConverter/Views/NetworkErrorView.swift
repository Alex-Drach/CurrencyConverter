//
//  NetworkErrorView.swift
//  CurrencyConverter
//
//  Created by Alex on 25.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// Shows an error and disappears automatically with fadeAway animation action.
class NetworkErrorView: UIView {
    
    /// Represents the view error states.
    enum State: Equatable {
        case connection
        case server
        case api
    }
    
    // - MARK: Properties
    private var text: String?
    private var textColor: UIColor?
    private var state: State
    
    private lazy var font: UIFont = {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        else {
            return UIFont.systemFont(ofSize: 23, weight: .semibold)
        }
    }()
    
    /// Initializes the NetworkErrorView frame with State.
    /// - Parameters:
    ///     - frame: - CGRect representation of the view.
    ///     - state: - Indicates an error state.
    /// - Returns: - A new NetworkErrorView object to display an error messege.
    init(frame: CGRect, state: State) {
        self.state = state
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK: Private Actions
    
    /// Set the View
    private func setView() {
        self.backgroundColor = .clear
        setError()
        setLable()
        setTimer()
    }
    
    /// Set UILabel for error text.
    private func setLable() {
        let lable = UILabel()
        lable.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        lable.textAlignment = .center
        lable.numberOfLines = 3
        
        guard let text = self.text,
              let color = textColor
        else { return }
        
        let colorAttribut = NSAttributedString.Key.foregroundColor
        let fontAttribut = NSAttributedString.Key.font
        lable.attributedText = NSMutableAttributedString(string: text, attributes: [colorAttribut: color, fontAttribut: font])
        self.addSubview(lable)
    }
    
    /// Set the error message according to the view state.
    private func setError() {
        switch state {
        case .connection:
            text = "Error! \n No internet connection ❌. \n Please check your network!"
            textColor = UIColor(red: 0.9933058619, green: 0.2981615663, blue: 0.1358174682, alpha: 1)
        case .api:
            text = "Error! Limited API ⌛️!"
            textColor = UIColor(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        case .server:
            text = "Error! \n Server is off! \n We are trying our best to fix it 🛠 !"
            textColor = UIColor(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        }
    }
    
    /// Set a timer to performe #selector action.
    private func setTimer() {
        Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(fadeAwayAction), userInfo: nil, repeats: false)
    }
    
    /// Removes the view from superView automatically with fadeAway animation action.
    @objc private func fadeAwayAction() {
        DispatchQueue.main.async { [self] in
            /// fadeAway action
            UIView.animate(withDuration: 5.0, animations: { self.alpha = 0 }) { [weak self] (true) in
                guard let self = self else { return }
                self.removeFromSuperview()
            }
        }
        
    }
    
}


