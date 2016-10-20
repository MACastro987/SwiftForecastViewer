//
//  SettingsViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    public var isFahrenheitSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextView()
        self.setupSegmentedControl()
        self.setupVisualEffects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let segIndex = UserDefaults.standard.value(forKey: "SegmentedControlIndexSelected") as? Int {
            segmentedControl.selectedSegmentIndex = segIndex
        }
    }
    
    func setupSegmentedControl() {
        let attr = NSDictionary(object: UIFont(name: "Avenir Next", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
        self.segmentedControl.setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
    }
    
    // MARK: - Blur & Vibrancy
    func setupVisualEffects() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        //Add the vibrancy view to the blur view
        blurEffectView.contentView.addSubview(vibrancyEffectView)
    }
    
    // MARK: - Text Field
    func setupTextView() {
        textField.layer.cornerRadius = 10
        textField.text = "Enter Your Zip Code"
        textField.textColor = UIColor.lightGray
        textField.keyboardType = UIKeyboardType.numberPad
        
        textField.inputAccessoryView = accessoryView()
        textField.inputAccessoryView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        self.view.addSubview(textField)
    }
    
    func accessoryView () -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let doneButton = UIButton()
        doneButton.frame = CGRect(x: self.view.frame.width - 80, y: 7, width: 60, height: 30)
        doneButton.backgroundColor = UIColor.clear
        doneButton.layer.cornerRadius = 10
        doneButton.titleLabel?.font = UIFont (name: "Avenir Next", size: 20.0)
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.4).cgColor
        doneButton.setTitle("done", for: .normal)
        doneButton.addTarget(self, action: #selector(SettingsViewController.doneAction), for: .touchUpInside)
        view.addSubview(doneButton)
        
        return view
    }
    
    func doneAction () {
        textField.resignFirstResponder()
        
        // save input to userdefaults
        let defaults = UserDefaults.standard
        defaults.set(textField.text, forKey: "ZipcodeInput")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
 
    // MARK: Tap Gesture
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Semented Control
    @IBAction func segmentedControlTap(_ sender: AnyObject) {
        let index = segmentedControl.selectedSegmentIndex
        self.saveSelectedIndex(index: index)

        if index == 0 {
            isFahrenheitSelected = true
        } else if index == 1 {
            isFahrenheitSelected = false
        }
    }
    
    func saveSelectedIndex(index: Int) {
        let defualts = UserDefaults.standard
        defualts.set(index, forKey: "SegmentedControlIndexSelected")
    }
}















