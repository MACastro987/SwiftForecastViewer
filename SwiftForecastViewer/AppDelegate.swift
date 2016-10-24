//
//  AppDelegate.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            
            self.reverseGeocode(location: location)
        }
    }
    
    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            guard let state = placeMark.addressDictionary?["State"] as? String else { return }
            
            guard let city = placeMark.addressDictionary?["City"] as? String else { return }
            let formatter = WeatherParser()
            
            if (!city.isEmpty) && (!state.isEmpty) {
                let cityFormatted = formatter.parseCityForRequest(city: city)
                self.requestWeather(city: cityFormatted as String, state: state as String)
                print(cityFormatted)
                print(state)
            }
        })
    }
    
    func requestWeather(city: String, state: String) {
        let request = WeatherRequest()
        request.requestWeather(forKey: .conditions, city: city, state: state)
        request.requestWeather(forKey: .hourly, city: city, state: state)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func parseCity(city: String) -> String {
        let parser = WeatherParser()
        let formattedCityString = parser.parseCityForRequest(city: city)
        
        return formattedCityString
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

