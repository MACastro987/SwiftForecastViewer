//
//  LocationUtil.swift
//  SwiftLocationClass
//
//  Created by Michael Castro on 9/23/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit
import CoreLocation

protocol locationDelegate {
    func locationRetrieved(_ latitude:Double, longitude:Double)
}

class LocationUtil: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var delegate:locationDelegate? = nil
    
    func updateUserLocation() -> Void {
        
        if !CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        locationManager.stopUpdatingLocation()

        
        if (delegate != nil) {
            
            // Remove:?
//            let latitude = locationValue.latitude
//            let longitude = locationValue.longitude
            
            // reverse geocode locations

            let location = CLLocation(latitude: locationValue.latitude, longitude: locationValue.longitude)
            self.reverseGeocodeLocation(location: location)

            
            // Change delegate function
//            delegate?.locationRetrieved(latitude, longitude: longitude)
        } else {
            print("No delegate")
        }
    }
    
    func reverseGeocodeLocation(location: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
            })
    }
    
    // LocationUtil Delegate
    func locationRetrieved(_ latitude: Double, longitude: Double) {
        print(latitude)
        
    }
}









