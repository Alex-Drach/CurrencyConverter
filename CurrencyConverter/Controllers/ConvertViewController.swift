//
//  ConvertViewController.swift
//  CurrencyConverter
//
//  Created by Alex on 19.04.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import UIKit

/// Presents currency conversion interface.
class ConvertViewController: UIViewController {
    
    // - MARK: Properties
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    @IBOutlet weak var chooseFirst: UIButton!
    @IBOutlet weak var chooseSecond: UIButton!
    @IBOutlet weak var reverse: UIButton!
    @IBOutlet weak var saveCurrency: UIButton!
    @IBOutlet weak var showCurrency: UIButton!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var firstCode: UILabel!
    @IBOutlet weak var secondCode: UILabel!
    
    var textOperator: TextFieldOperator?
    var networkOperator: NetworkOperator?
    var animationOperator: AnimationOperator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProperties()
    }
    /// Preparing a presented ViewController before presentation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let navigator = segue.destination as? UINavigationController,
              let presented = navigator.viewControllers[0] as? CurrencyViewController
        else { return }
        
        switch(sender as? UIButton) {
        case chooseFirst:
            presented.viewState = .createContent(.first)
            presented.restrictedCode = secondCode.text
        case chooseSecond:
            presented.viewState = .createContent(.second)
            presented.restrictedCode = firstCode.text
        case saveCurrency:
            presented.viewState = .savedContent(.saver)
        case showCurrency:
            presented.viewState = .savedContent(.visitor)
        default: return
        }
    }
    
    /// Actions with a touch.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        amount.endEditing(true)
    }
    
    // - MARK: Private Actions
    
    /// Initializes the ViewController properties.
    private func initProperties() {
        firstCode.text = ""; secondCode.text = ""; amount.text = ""; result.text = "";
        animationOperator = AnimationOperator(
            animationView: animationView,
            activityIndicator: activityIndicator,
            reverseButton: reverse,
            firstButton: chooseFirst,
            secondButton: chooseSecond,
            firstCode: firstCode,
            secondCode: secondCode,
            amount: amount,
            result: result)
        textOperator = TextFieldOperator(amount)
        networkOperator = NetworkOperator()
        networkOperator?.delegate = self
    }
    
    /// Reverses converted currencies clockwise.
    @IBAction private func reverseCurrency(_ sender: UIButton) {
        animationOperator?.reverse()
    }
    /// Convertes chosen currencies.
    @IBAction private func convertCurrency(_ sender: UIButton) {
        result.text = ""
        amount.endEditing(true)
        if firstCode.text == result.text || secondCode.text == result.text ||  amount.text == result.text {
            animationOperator?.shakeComponents()
        }
        else {
            networkOperator?.getData(sum: amount.text ?? "", from: firstCode.text ?? "", to: secondCode.text ?? "")
        }
    }
    
    /// Presents saved or loaded data.
    @IBAction private func presentData(_ sender: UIButton) {
        amount.endEditing(true)
        guard let animationOperator = self.animationOperator else { return }
        if sender == saveCurrency && animationOperator.canAnimate() {
            animationOperator.shakeComponents()
        }
        else { performSegue(withIdentifier: "presentData", sender: sender) }
    }
    
    /// Presents an error in the ViewController's view.
    /// - Parameters:
    ///     - state: - Indicates NetworkErrorView state.
    private func presentError(state: NetworkErrorView.State) {
        animationOperator?.stopConnectionAnimation(success: false)
        let height: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 70.0 : 100.0
        let frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: height)
        let errorView = NetworkErrorView(frame: frame, state: state)
        view.addSubview(errorView)
    }
}

// - MARK: NetworkOperatorDelegate
extension ConvertViewController: NetworkOperatorDelegate {
    
    func networkOperator(_ networkOperator: NetworkOperator, didChangeState state: NetworkOperator.States) {
        DispatchQueue.main.async { [self] in
            
            switch state {
            case .beganConnecting:
                animationOperator?.startConnectionAnimation()
            case .connectionError:
                presentError(state: .connection)
            case .infoSupport:
                presentError(state: .api)
            case .serverDied:
                presentError(state: .server)
            case .finished:
                animationOperator?.stopConnectionAnimation(success: true)
                result.text = networkOperator.result
            }
        }
    }
}
