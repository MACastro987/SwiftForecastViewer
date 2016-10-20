//
//  SettingsViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
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
    
    func setupTextView() {
        textView.textContainer.maximumNumberOfLines = 1
        textView.layer.cornerRadius = 10
        textView.text = "Enter Your Zip Code"
        textView.textColor = UIColor.lightGray
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
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















