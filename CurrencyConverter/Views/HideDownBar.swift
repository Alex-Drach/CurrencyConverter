//
//  DragDownBar.swift
//  CurrencyConverter
//
//  Created by Alex on 23.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// It's custom toolbar, created by a reason the numberPad keyboard doesn't have a toolbar.
/// It has convenient a hide-down action for keyboard dismissing.
class HideDownBar: UIToolbar {
    
    // - MARK: Properties
    private var hide: UIButton?
    private var hideAction: () -> Void?
    
    /// Initializes the HideDownBar frame with action.
    /// - Parameters:
    ///     - frame: - CGRect representation of the toolBar view.
    ///     - action: - Indicates an action to be performed by the toolBar button.
    /// - Returns: - A new HideDownBar object to display an error messege.
    init(frame: CGRect, action: @escaping () -> Void) {
        self.hideAction = action
        super.init(frame: frame)
        setToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // - MARK: Private Actions
    
    /// Sets bar's properties.
    private func setToolbar() {
        setHide()
        guard let hideButton = hide else { return }
        self.barTintColor = .clear
        self.backgroundColor = UIColor(red: 0.7803921569, green: 0.7803921569, blue: 0.8, alpha: 0.9004708904)
        self.isOpaque = false
        self.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let hideDown = UIBarButtonItem.init(customView: hideButton)
        self.setItems([flexibleSpace, hideDown, flexibleSpace], animated: true)
    }
    
    /// Sets the bar's hide button.
    private func setHide() {
        hide = UIButton()
        if UIDevice.current.userInterfaceIdiom == .pad{
            hide?.frame = CGRect(x: 0, y: 0, width: 160, height: 4)
        }
        else{
            hide?.frame = CGRect(x: 0, y: 0, width: 80, height: 4)
        }
        hide?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        hide?.contentMode = .scaleAspectFit
        hide?.setBackgroundImage(UIImage(named: "drag"), for: .normal)
        hide?.addTarget(self, action: #selector(dragDown), for: .touchDown)
    }
    
    /// Hides the bar keyboard on dragDown.
    @objc private func dragDown() {
        hideAction()
    }
    
}
