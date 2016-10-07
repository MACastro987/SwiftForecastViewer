//
//  CurrentWeatherParser.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/6/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import Foundation

class WeatherParser {
    
    let units = 0   // 0 = Fahrenheight, 1 = Celsius
    
    func currentDisplayDataFrom(json: [String: Any]?) -> CurrentDisplayData? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        guard let location = observe["display_location"] as? [String: Any] else { return nil }
        guard let full = location["full"] as? String else { return nil }
        
        guard let weather = observe["weather"] as? String else { return nil }

        let keyT = units == 0 ? "temp_f" : "temp_c"
        guard let temp = observe[keyT] as? Float else { return nil }
        
        //Parse into formated string
        let roundedTemp = Int(round(Double(temp)))
        let tempString = "\(roundedTemp)\u{00B0}"
        
        
        return CurrentDisplayData(temperature: tempString, cityAndState: full, weather: weather)
    }
}
