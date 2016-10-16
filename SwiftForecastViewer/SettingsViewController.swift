//
//  SettingsViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var getWeatherButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTextView()
        self.setupSegmentedControl()
        self.setupVisualEffects()
    }
    
    func setupSegmentedControl() {
        let attr = NSDictionary(object: UIFont(name: "Avenir Next", size: 12.0)!, forKey: NSFontAttributeName as NSCopying)
        self.segmentedControl.setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
    }
    
    func setupVisualEffects() {
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        view.addSubview(blurEffectView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        view.insertSubview(blurEffectView, at: 0)
//        view.addSubview(blurEffectView)
        

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        //Add the vibrancy view to the blur view
        blurEffectView.contentView.addSubview(vibrancyEffectView)
    }
    
    func setupTextView() {
        textView.textContainer.maximumNumberOfLines = 1
        textView.layer.cornerRadius = 10
    }
    
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
