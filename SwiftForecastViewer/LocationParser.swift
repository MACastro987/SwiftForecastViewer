//
//  LocationParser.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/21/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import Foundation
import CoreLocation

class LocationParser {
    var locationString: String?
    
    func parseCurrentLocation() -> String? {
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
                if let city = placeMark.addressDictionary?["City"] as? String
                {
                    print(city)
                    cityName = city
                }
                
                var stateName = ""
                if let state = placeMark.addressDictionary?["State"] as? String {
                    print(state)
                    stateName = state
                }
                
                self.locationString = "\(cityName), \(stateName)"
            })}
        
        return locationString
    }
}
