//
//  UIViewAnimations.swift
//  CurrencyConverter
//
//  Created by Alex on 14.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

// - MARK: UIView animation actions
extension UIView {

    /// Rotates UIView with a rotation angle in degrees.
    /// - Parameters:
    ///     - rotationAngle: - It's like: 180, 360 or CGFloat.pi.
    public func rotate(rotationAngle: CGFloat) {
        DispatchQueue.main.async { [self] in
            UIView.animate(withDuration: 1.35, animations: {
                self.transform = CGAffineTransform(rotationAngle: rotationAngle)
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    /// Makes UIView shake for a moment. It's useful for highlighting some user actions.
    public func shake() {
        DispatchQueue.main.async { [self] in
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.duration = 0.6
            animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
            layer.add(animation, forKey: "shake")
        }
    }
    
    /// Makes UIView pulsate for a while. It's useful for highlighting some user actions.
    public func pulsate() {
        DispatchQueue.main.async { [self] in
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.3
            pulse.fromValue = 0.95
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = 2
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
            layer.add(pulse, forKey: "pulse")
        }
    }
    
}

// - MARK: UIImageView animation actions
extension UIImageView {
    
    /// Animates UIImageView with a range of spinning images.
    /// - Parameters:
    ///     - images: - Array of UIImages like: [UIImage].
    public func spin(with images: [UIImage]) {
        DispatchQueue.main.async { [self] in
            self.animationImages = images
            self.animationDuration = 0.40
            self.animationRepeatCount = 4
            self.startAnimating()
        }
    }
    
}
