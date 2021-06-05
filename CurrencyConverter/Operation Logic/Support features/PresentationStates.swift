//
//  PresentationStates.swift
//  CurrencyConverter
//
//  Created by Alex Drach on 04.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import Foundation

/// Indicates different ViewModel presentation states to display different data content in a same view.
enum PresentationStates: Equatable {
    
    /// Defines content creation for a presented view.
    case createContent(ContentAlias)
    
    /// Defines content loading from a saved data for a presented view.
    case savedContent(SavedContentAlias)
    
    /// Indicates what part of the created content will be available.
    enum  ContentAlias {
        /// Indicates content creation from first source.
        /// If it's first, second unavailable.
        case first
        /// Indicates content creation from second source.
        /// If it's second, first unavailable.
        case second
    }
    /// Indicates who is going to open a saved content.
    enum SavedContentAlias {
        /// Adds a new data content before presenting a saved content.
        /// Shows recently added content with the saved content together.
        case saver
        /// Looks in a saved content and presents it.
        case visitor
    }
}
