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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var today = [hourData]()
    var tomorrow = [hourData]()

        
    let reuseIdentifier = "MainCell"
    var isFahrenheit = true
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.setupNotifications()
        
        // Set initial value of SettingsVC's SegController 
        // to correspond with the initial value of teh isFahrenheit
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "SegmentedControlIndexSelected")
    }
    
    // MARK: - Unwind From Settings
    @IBAction func unwindWithUnitsOfMeasure (sender: UIStoryboardSegue) {
        
        var unitsDidChange = false
        
        if sender.source is SettingsViewController {
            
            let defaults = UserDefaults.standard
            if let segIndex = defaults.value(forKey: "SegmentedControlIndexSelected") {
                
                // Check unitsDidChange:
                if (segIndex as! Bool) == self.isFahrenheit {
                    unitsDidChange = true
                    
                    if (segIndex as! Int) != 0 {
                        self.isFahrenheit = false
                    } else {
                        self.isFahrenheit = true
                    }
                }
            }
        }
        
        let defaults = UserDefaults.standard
        guard let locationDidChange = defaults.value(forKey: "LocationDidChange") else { return }
        
        print("locationDidChange : \(locationDidChange)")
        
        // if units have changed
        // && location has not changed - Set in SettingsVC
        if unitsDidChange && (!(locationDidChange as! Bool)) {
            // Update units from stored value
            // Background
            self.updateTempLabel()
            // CollectionView
            // Reload CollectionView now that units of measure is set
            self.collectionView.reloadData()
            
        }
        else {
            // Location changed
            // Request weather again
            self.parseLocation()
        }
    }
    
    var city = String()
    var state = String()
    
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
                
                if let cityName = placeMark.addressDictionary?["City"] as? String {
                    self.city = cityName
                }
                
                if let stateName = placeMark.addressDictionary?["State"] as? String {
                    self.state = stateName
                }
                
                // Parse
                let parser = WeatherParser()
                self.city = parser.parseCityForRequest(city: self.city)
                
                self.requestNewData(city: self.city, state: self.state)
                
            })}
        }
    
    func requestNewData(city: String, state: String) {
        let weatherRequest = WeatherRequest()
        weatherRequest.requestWeather(forKey: .conditions, city: city, state: state)
        weatherRequest.requestWeather(forKey: .hourly, city: city, state: state)
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
    
    // MARK: - Notifications
    func setupNotifications() {
        
        // Background Labels
        let backgroundLabelDataNotif = Notification.Name("UpdateBackground")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBackgroundUI(notification:)), name: backgroundLabelDataNotif, object: nil)
        
        // CollectionView Data
        let collectionViewDataNotif = Notification.Name("UpdateCollectionView")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollectionView(notification:)), name: collectionViewDataNotif, object: nil)
    }
    
    // Notifications Helpers
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var currentBackgroundData = currentDisplayData(english: nil, metric: nil, cityAndState: nil, weather: nil, coolColor: nil)
    
    func updateBackgroundUI(notification: Notification) {
        currentBackgroundData = notification.object as! currentDisplayData
        
        let isCool = currentBackgroundData.coolColor!
        var temp = currentBackgroundData.english
        if !isFahrenheit {
            temp = currentBackgroundData.metric
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.tempLabel.text = temp
                self.weatherLabel.text = self.currentBackgroundData.weather
                self.locationLabel.text = self.currentBackgroundData.cityAndState
                self.setBackgroundColor(cool: isCool)
            }
        }
    }
    
    func setBackgroundColor(cool: Bool) {
        switch cool {
        case true:
            self.view.backgroundColor = UIColorFromRGB(rgbValue: 0x03A9F4) // coolColor
        case false:
            self.view.backgroundColor = UIColorFromRGB(rgbValue: 0xFF9800) // warmColor
        }
    }
    
    // Initialize an empty array to hold forecastData
    var forecast = forecastData(today: nil, tomorrow: nil)
    
    func updateCollectionView(notification: Notification) {
        
        forecast = (notification.object as? forecastData)!
        today = forecast.today!
        tomorrow = forecast.tomorrow!
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.size.width
        let cellHeight = collectionView.frame.size.height / 2
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let insetViewController = self.storyboard?.instantiateViewController(withIdentifier: "InnerCollectionController") as! InnerCollectionViewController
        if !isFahrenheit {
            insetViewController.isFahrenheit = false
        } else if isFahrenheit {
            insetViewController.isFahrenheit = true
        }
        
        let itemIndex = indexPath.row + indexPath.section
        
        if itemIndex == 0 {
            insetViewController.isTodayForecast = true
            if !today.isEmpty {
                insetViewController.updateCollection(forecastArray: today)
            }
        } else if itemIndex == 1 {
            insetViewController.isTodayForecast = false
            if !tomorrow.isEmpty {
                insetViewController.updateCollection(forecastArray: tomorrow)
            }
        } else {
            print("Error setting cellForItemAt indexPath")
        }
        
        self.addChildViewController(insetViewController)
        cell.addSubview((insetViewController.view)!)
        
        return cell
    }
}
