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
}

struct WeatherRequest {
    let baseUrl = "api.wunderground.com"
    let apiKey = "4aa1b354ada978c6"
    let currentWeatherkey = "current_observation"
    
    func requestWeather(forKey key: WeatherKeys) -> Void {
        
//        let url = URL(string: "http://\(baseUrl)/api/\(apiKey)/\(currentWeatherkey)/q/\(state)/\(city).json")
        
        let testUrl = URL(string: "http://api.wunderground.com/api/4aa1b354ada978c6/conditions/q/CA/San_Francisco.json")
              
        let req = NSMutableURLRequest(url: testUrl!)
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            if error != nil {
                //Error
                print(error?.localizedDescription)
            } else {
                //Success
                print(String(data: data!, encoding: String.Encoding.utf8))
                
                self.parse(data: data!)
            }
        }.resume()
    }
    
    func parse(data: Data) {
        let json: [String: Any]?
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            json = nil
            print("Error is \(error.localizedDescription)")
        }
        
        let parser = WeatherParser()
        let currentDisplayData = parser.currentDisplayDataFrom(json: json!)
        self.updateCurrentDiplayWith(data: currentDisplayData!)
    }
    
    func updateCurrentDiplayWith(data: CurrentDisplayData) {
        let notificationName = Notification.Name("UpdateUI")
        NotificationCenter.default.post(name: notificationName, object: data)
    }
}

















