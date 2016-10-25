//
//  ViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


class MainViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
        
    let reuseIdentifier = "MainCell"
    var isFahrenheit = true
    
    // warmColor : 0xFF9800
    // coolColor : 0x03A9F4
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.setupNotifications()
        
        //testing
//        self.view.backgroundColor = UIColorFromRGB(rgbValue: 0xFF9800)
        self.view.backgroundColor = UIColorFromRGB(rgbValue: 0x03A9F4)
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
            }
            
            // Update tempLabel with change in units
            self.updateTempLabel()
            
            // Update locationLabel
            self.parseLocation()
        }
    }
    
    // TODO: Encapsulate in Geocoder class
    //************************************
    
    func parseLocation() {
        // Get current zip code
        if let zipString = (UserDefaults.standard.value(forKey: "ZipcodeInput")) as? String {
            // Reverse geocode location name
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(zipString, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // Address dictionary
                print("Address Dict : \(placeMark.addressDictionary)")
                
                // Location name
                var cityName = ""
                if let city = placeMark.addressDictionary?["City"] as? String {
                    cityName = city
                }
                
                var stateName = ""
                if let state = placeMark.addressDictionary?["State"] as? String {
                    stateName = state
                }
                
                let cityAndState = "\(cityName), \(stateName)"
                
                // Parse
                let parser = WeatherParser()
                let formattedCity = parser.parseCityForRequest(city: cityName)
                
                self.requestNewData(city: formattedCity, state: stateName)
                
                self.updateLocationLabel(with: cityAndState)
            })}
        }
    
    func requestNewData(city: String, state: String) {
        let weatherRequest = WeatherRequest()
        weatherRequest.requestWeather(forKey: .conditions, city: city, state: state)
        weatherRequest.requestWeather(forKey: .hourly, city: city, state: state)
    }
    
    func updateLocationLabel(with string: String) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.locationLabel.text = string
            }
        }
    }
    
    func updateTempLabel() {
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
        
        //TODO: Remove Placeholder values
        let city = "Kansas_City"
        let state = "MO"
        
        
        
        let weatherRequest = WeatherRequest()
        weatherRequest.requestWeather(forKey: .conditions, city: city, state: state)
        weatherRequest.requestWeather(forKey: .hourly, city: city, state: state)
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
