//
//  TextFieldOperator.swift
//  CurrencyConverter
//
//  Created by Alex on 07.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.


import UIKit

/// Operates UITextField actions.
class TextFieldOperator: NSObject {
    
    // - MARK: Properties
    private var textField: UITextField
    let deviceState = UIDevice.current.userInterfaceIdiom
    
    // - MARK: Initialization
    
    /// Initializes the TextFieldOperator components.
    /// - Parameters:
    ///     - textField: - UITextField - where a user types text.
    /// - Returns: - A new TextFieldOperator object to perform defined typing text actions.
    init(_ textField: UITextField) {
        self.textField = textField
        super.init()
        setupTextField()
    }
    
    // - MARK: Private Actions
    
    private func setupTextField() {
        textField.delegate = self
        setPlaceholder()
        setToolbar()
    }
    
    /// Toolbar for the textField.
    private func setToolbar() {
        let hideDown = HideDownBar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 8), action: endEdit)
        textField.inputAccessoryView = hideDown
    }
    /// End editing
    private func endEdit() {
        textField.endEditing(true)
    }
    
    /// Placeholder for currencyTexField
    private func setPlaceholder() {
        let textPlaceholder = "Enter amount..."
        let font: CGFloat = deviceState == .phone ? 20 : 42
        textField.attributedPlaceholder = NSAttributedString(
            string: textPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0),
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: font, weight: .regular)])
    }
    
}

// - MARK: TextFieldDelegate
extension TextFieldOperator: UITextFieldDelegate {
    
    // When a user types text, the entered text must fit to the app needs.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// Indicates text components separated by a character.
        guard let components = textField.text?.components(separatedBy: ".").count else { return false}
        /// Indicates dots count.
        let dots = components - 1
        
        /// Must be one dot.
        if dots > 0 && (string == "." || string == ",") {
            return false
        }
        /// Dot must not be the first character in range.
        else if textField.text?.count == 0 && (string == "." || string == ",") {
            return false
        }
        /// Replaces coma with dot, if coma was entered.
        else if string == "," {
            textField.text? += "."
            return false
        }
        /// iPad keyboard must operate only with numbers like iPhone.
        else if deviceState == .pad {
            let neededCharacters = "1234567890."
            let charSet = CharacterSet(charactersIn: neededCharacters)
            let enteredCharSet = CharacterSet(charactersIn: string)
            return charSet.isSuperset(of: enteredCharSet)
        }
        else { return true }
    }
    
    /// When textField end editing, the entered text must be corrected properly.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        /// Must be only two characters after dot.
        textField.text = correct(charsIn: textField.text ?? "")
        /// Text must not contain only zero and dots characters.
        if restrictedChar(in: textField.text ?? "") {
            textField.text = ""
        }
    }
    
    
// - MARK: TextFieldDelegate+Helpers
    
    /// Checks for restricted characters, which are '0' and '.', without any other chars entered.
    /// - Parameters:
    ///     - text: - Indicates a string, to look for restricted characters.
    /// - Returns: - A bool value telling whether restricted characters exist.
    private func restrictedChar(in text: String) -> Bool {
        var indicator = true
        for char in text where char != "0" && char != "." {
            indicator = false
        }
        return indicator
    }
    
    /// Corrects characters in text.
    /// - Parameters:
    ///     - text: - Indicates a string with text to be changed.
    /// - Returns: - String representation of corrected text.
    private func correct(charsIn text: String) -> String {
        let components = text.components(separatedBy: ".")
        let firstComponent = components[0].count + 3
        let dotContains = text.contains(".")
        var string = text
        
        if dotContains && string.count > firstComponent {
            string.removeLast(firstComponent.distance(to: string.count))
        }
        else if !dotContains && text.last != "." {
            string += ".00"
        }
        else if text.last == "." {
            string += "00"
        }
        else if text.contains(".") && components[1].count == 1 {
            string += "0"
        }
        return string
    }
    
}
