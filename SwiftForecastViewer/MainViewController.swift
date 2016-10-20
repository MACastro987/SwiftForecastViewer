//
//  ViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
        
    let reuseIdentifier = "MainCell"
    var isFahrenheit = true
        
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.requestWeather()
        self.setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Main.isFahrenheit? : \(isFahrenheit)")
        
    }
    
    // MARK: - Unwind
    @IBAction func unwindWithUnitsOfMeasure (sender: UIStoryboardSegue) {
        if sender.source is SettingsViewController {
            let settings = sender.source as! SettingsViewController
            print("settings.isFahrenheitSelecte : \(settings.isFahrenheitSelected)")
            
            if self.isFahrenheit != settings.isFahrenheitSelected {
                self.isFahrenheit = settings.isFahrenheitSelected
                
                // Update tempLabel with change in units
                self.upadateTempLabel()
            }
        }
    }
    
    func upadateTempLabel() {
        
        if let tempValues = UserDefaults.standard.value(forKey: "CurrentTemperatureValues") as? NSDictionary {
            let english = tempValues.value(forKey: "english") as! String
            let metric = tempValues.value(forKey: "metric") as! String
            
            let temparature: String
            switch isFahrenheit {
            case true:
                temparature = english
            case false:
                temparature = metric
            }
            
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.tempLabel.text = temparature
                }
            }
        }
    }
    
    // MARK: - WeatherRequests
    func requestWeather() {
        let weatherRequest = WeatherRequest()
        weatherRequest.requestWeather(forKey: .conditions)
        weatherRequest.requestWeather(forKey: .hourly)
    }
    
    // MARK: - Notifications
    func setupNotifications() {
        // Background Labels
        let backgroundLabelDataNotif = Notification.Name("UpdateBackground")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBackgroundUI(notification:)), name: backgroundLabelDataNotif, object: nil)
        // CollectionView Data
        let collectionViewDataNotif = Notification.Name("UpdateCollectionView")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollectionView(notification:)), name: collectionViewDataNotif, object: nil)
    }
    
    func updateBackgroundUI(notification: Notification) {
        let currentArray: currentDisplayData = notification.object as! currentDisplayData
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.tempLabel.text = currentArray.english
                self.weatherLabel.text = currentArray.weather
                self.locationLabel.text = currentArray.cityAndState
            }
        }
    }
    
    func updateCollectionView(notification: Notification) {
        print(notification)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}
