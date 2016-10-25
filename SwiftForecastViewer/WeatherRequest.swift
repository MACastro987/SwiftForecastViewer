//
//  WeatherRequest.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/7/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import Foundation

enum WeatherKeys : String {
    case conditions = "conditions"
    case hourly = "hourly"
}

struct WeatherRequest {
    let baseUrl = "api.wunderground.com"
    let apiKey = "4aa1b354ada978c6"
    let currentWeatherkey = "current_observation"
    
    func requestWeather(forKey key: WeatherKeys, city: String, state: String) -> Void {
        
        //let url = URL(string: "http://\(baseUrl)/api/\(apiKey)/\(currentWeatherkey)/q/\(state)/\(city).json")
        
        let testUrl = URL(string: "http://api.wunderground.com/api/4aa1b354ada978c6/\(key)/q/\(state)/\(city).json")
              
        let req = NSMutableURLRequest(url: testUrl!)
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            if error != nil {
                //Error
                print(error?.localizedDescription)
            } else {
                //Success
                //print(String(data: data!, encoding: String.Encoding.utf8))
                
                self.parse(data: data!, givenCase: key)
            }
        }.resume()
    }
    
    func parse(data: Data, givenCase: WeatherKeys) {
        let json: [String: Any]?
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            json = nil
            print("Error is \(error.localizedDescription)")
        }
        
        let parser = WeatherParser()
        let defaults = UserDefaults.standard
        
        switch givenCase {
            
        case .conditions:
            print("fetching current conditions")
            let currentDisplayData = parser.currentDisplayDataFrom(json: json!)
            self.notifyCurrentDiplay(data: currentDisplayData!)
            
            //Save a dictionary of temperatures 
            let temps: [String: String] = [
                "english": (currentDisplayData?.english)!,
                "metric": (currentDisplayData?.metric)!
            ]
            
            defaults.set(temps, forKey: "CurrentTemperatureValues")
            
        case .hourly:
            print("fetching hourly forecast")
            let forecastData = parser.forecastDataFrom(json: json!)
            self.notifyCollectionView(forecast: forecastData)
        }
    }
    
    // MARK: - Data Nofications
    func notifyCurrentDiplay(data: currentDisplayData) {
        let notificationName = Notification.Name("UpdateBackground")
        NotificationCenter.default.post(name: notificationName, object: data)
    }

    func notifyCollectionView(forecast: forecastData) {
        let notificationName = Notification.Name("UpdateCollectionView")
        NotificationCenter.default.post(name: notificationName, object: forecast)
    }
}
