//
//  AnimationOperator+Animations.swift
//  CurrencyConverter
//
//  Created by Alex Drach on 02.06.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

extension AnimationOperator {
    
    // - MARK: Animations
    
    /// Starts connection animation.
    public func startConnectionAnimation() {
        activityIndicator.startAnimating()
        animationView.isHidden = false
        animationView.spin(with: images(number: 6, prefix: "animation"))
    }
    /// Stops connection animation with bool value.
    /// - Parameters:
    ///     - success: - It's bool value: if 'true' will be done pulsate animation action.
    public func stopConnectionAnimation(success: Bool) {
        animationView.isHidden = true
        animationView.stopAnimating()
        activityIndicator.stopAnimating()
        if success {
            firstButton.pulsate()
            secondButton.pulsate()
        }
    }
    
    /// Reverses UI Components clockwise.
    public func reverse() {
        amount.endEditing(true)
        reverseButton.rotate(rotationAngle: CGFloat.pi)
        if !canAnimate() {
            /// Temporary properties to keep value of UI Components.
            let firstImage = self.firstButton.currentBackgroundImage
            let firstAmount = self.amount.text
            let firstCode = self.firstCode.text
            let secondImage = self.secondButton.currentBackgroundImage
            let secondAmount = self.result.text
            let secondCode = self.secondCode.text
            
            DispatchQueue.main.async { [self] in
                /// Chain UIView animations.
                UIView.animate(withDuration: 0.35, animations: { self.firstButton.alpha = 0 }) { [weak self] (true) in
                    guard let self = self else { return }
                    self.firstButton.setBackgroundImage(secondImage, for: .normal)
                    self.amount.text = ""
                    self.firstCode.text = ""
                    
                    UIView.animate(withDuration: 0.35, animations: { self.secondCode.text = "" }, completion: { [weak self] (true) in
                        guard let self = self else { return }
                        self.result.text = ""
                        self.secondButton.alpha = 0
                        self.secondButton.setBackgroundImage(firstImage, for: .normal)
                        
                        UIView.animate(withDuration: 0.35, animations: { self.firstButton.alpha = 1 }, completion: { [weak self] (true) in
                            guard let self = self else { return }
                            self.amount.text = secondAmount
                            self.firstCode.text = secondCode
                            
                            UIView.animate(withDuration: 0.35, animations: { self.secondCode.text = firstCode }, completion: {
                                [weak self] (true) in
                                guard let self = self else { return }
                                self.result.text = firstAmount
                                self.secondButton.alpha = 1
                            })
                        })
                    })
                }
            }
        }
        else { shakeComponents() }
    }
    
    /// Animates UI components with a shake animation actions.
    public func shakeComponents() {
        if firstCode.text == empty {
            firstCode.shake()
            firstButton.shake()
        }
        else if amount.text == empty {
            amount.shake()
        }
        else if secondCode.text == empty {
            secondCode.shake()
            secondButton.shake()
        }
        else if result.text == empty {
            result.shake()
        }
    }
    
}
