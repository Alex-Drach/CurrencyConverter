//
//  AnimationOperator.swift
//  CurrencyConverter
//
//  Created by Alex on 14.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// The class is responsible for the ConvertViewController UI components animations.
class AnimationOperator {
    
    // - MARK: Properties
    let empty: String = ""
    var animationView: UIImageView
    var activityIndicator: UIActivityIndicatorView
    var reverseButton: UIButton
    var firstButton: UIButton
    var secondButton: UIButton
    var amount: UITextField
    var firstCode: UILabel
    var secondCode: UILabel
    var result: UILabel
    
    /// Initializes a ViewController UI components to animate.
    /// - Parameters:
    ///     - animationView: - UIImageView for animating currency converting process.
    ///     - activityIndicator: - Indicates presenting of converted amount to a user.
    ///     - reverseButton: - UIButton - animated when the AnimationOperator reverses value.
    ///     - firstButton: - UIButton - animated with pulsate animation when currencies are converted.
    ///     - secondButton: - UIButton - animated with pulsate animation when currencies are converted.
    ///     - firstCode: - UILable - is animated with a shake animation if it's empty.
    ///     - secondCode: - UILable - is animated with a shake animation if it's empty.
    ///     - amount: - UITextField - is animated with a shake animation if it's empty.
    ///     - result: - UILable - is animated with a shake animation if it's empty.
    /// - Returns: - A new AnimationOperator object to perform defined animation actions.
    init(animationView: UIImageView, activityIndicator: UIActivityIndicatorView, reverseButton: UIButton, firstButton: UIButton, secondButton: UIButton, firstCode: UILabel, secondCode: UILabel, amount: UITextField, result: UILabel)
    {
        self.animationView = animationView
        self.activityIndicator = activityIndicator
        self.reverseButton = reverseButton
        self.firstButton = firstButton
        self.secondButton = secondButton
        self.firstCode = firstCode
        self.secondCode = secondCode
        self.amount = amount
        self.result = result
    }
    
    /// Returns bool value, indicating whether UI elements can be animated.
    public func canAnimate() -> Bool {
        if amount.text == empty {
            return true
        }
        else if result.text == empty {
            return true
        }
        else if firstCode.text == empty {
            return true
        }
        else if secondCode.text == empty {
            return true
        }
        else {return false}
    }
    
    /// Automatically generates an images array from assets catalog.
    /// - Parameters:
    ///     - all: - Indicates total number of animation images.
    ///     - prefix: - Indicates the same prefix of each image.
    /// - Returns: - UIImage array like: [UIImage].
    func images(number all: Int, prefix: String) -> [UIImage] {
        var images: [UIImage] = []
        for imageNumber in 1...all {
            if let image = UIImage(named: "\(prefix)\(imageNumber)") {
                images.append(image)
            }
        }
        return images
    }
    
}
