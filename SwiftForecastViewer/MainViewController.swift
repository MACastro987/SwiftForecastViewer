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
    
    override func viewWillAppear(_ animated: Bool) {
        //print("Main.isFahrenheit? : \(isFahrenheit)")
        
    }
    
    // MARK: - Unwind From Settings
    @IBAction func unwindWithUnitsOfMeasure (sender: UIStoryboardSegue) {
        
        if sender.source is SettingsViewController {
            
            let defaults = UserDefaults.standard
            if let segIndex = defaults.value(forKey: "SegmentedControlIndexSelected") {
                if (segIndex as! Int) == 1 {
                    // Metric 
                    self.isFahrenheit = false
                }
            }
//            let settings = sender.source as! SettingsViewController
            //print("settings.isFahrenheitSelecte : \(settings.isFahrenheitSelected)")
            
//            if self.isFahrenheit != settings.isFahrenheitSelected {
//                self.isFahrenheit = settings.isFahrenheitSelected
//            }
            
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
                
                // Location name
                var cityName = ""
                if let city = placeMark.addressDictionary?["City"] as? String {
                    cityName = city
                }
                
                var stateName = ""
                if let state = placeMark.addressDictionary?["State"] as? String {
                    stateName = state
                }
                
                // Parse
                let parser = WeatherParser()
                let formattedCity = parser.parseCityForRequest(city: cityName)
                
                self.requestNewData(city: formattedCity, state: stateName)
                
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
    
    func updateBackgroundUI(notification: Notification) {
        let currentArray: currentDisplayData = notification.object as! currentDisplayData
        let isCool = currentArray.coolColor
        var temp = currentArray.english
        if !isFahrenheit {
            temp = currentArray.metric
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.tempLabel.text = temp
                self.weatherLabel.text = currentArray.weather
                self.locationLabel.text = currentArray.cityAndState
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
    
    func updateCollectionView(notification: Notification) {
        if let forecasts = notification.object as? forecastData {
            today = forecasts.today
            tomorrow = forecasts.tomorrow
            
            collectionView.reloadData()
        }
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


