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
    
    func currentDisplayDataFrom(json: [String: Any]?) -> currentDisplayData? {
        
        guard let json = json else { return nil }
        
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        guard let location = observe["display_location"] as? [String: Any] else { return nil }
        guard let full = location["full"] as? String else { return nil }
        
        guard let weather = observe["weather"] as? String else { return nil }
        
        var coolColor = true
        var english = ""
        if let fahrenheit = observe["temp_f"] as? Float {
            english = formatTemperature(temperature: fahrenheit)
            
            if fahrenheit > 73 {
                coolColor = false
            }
        }
        
        var metric = ""
        if let celcius = observe["temp_c"] as? Float {
            metric = formatTemperature(temperature: celcius)
        }

        return currentDisplayData(english: english, metric: metric, cityAndState: full, weather: weather, coolColor: coolColor)
    }
    
    // Current Data Helper
    func formatTemperature(temperature: Float) -> String {
        let roundedTemperature = round(temperature)
        let intTemp = Int(roundedTemperature)
        let degreeSymbolFormat = "\(intTemp)\u{00B0}"

        return degreeSymbolFormat
    }
    
    func forecastDataFrom(json: [String: Any]?) -> forecastData {
        
        // Create an empty array to which hourData will be appended
        var forecast = [hourData]()
        
        let json = json! as [String: Any]
        let hourlyForecast = json["hourly_forecast"] as! NSArray
        
        // Iterate through the forecast response retrieving data about each hour
        for hour in hourlyForecast {
            let hourDict = hour as! NSDictionary
            let meta = hourDict["FCTTIME"] as! NSDictionary

            // Day
            let day = meta["weekday_name"] as! String
            
            // Time
            let civilTime = meta["civil"]
            let time = civilTime as! String
            
            // Icon url
            let iconUrl = hourDict["icon_url"] as! String
            let url = URL(string: iconUrl)!
            
            // Temperature
            let temp = hourDict["temp"] as! NSDictionary
            let english = self.addDegreeSymbol(stringIn: temp["english"] as! String)
            let metric = self.addDegreeSymbol(stringIn: temp["metric"] as! String)
            
            let data = hourData(day: day, time: time, english: english, metric: metric, icon: url)
            
            forecast.append(data)
        }
        
        return(hourDataByDayFrom(forecast: forecast))
    }
    
    func addDegreeSymbol(stringIn: String) -> String {
        let stringOut = "\(stringIn)\u{00B0}"
        return stringOut
    }
    
    // Forecast Helper
    
    func hourDataByDayFrom(forecast: Array<hourData>) -> forecastData {
        var todayForecast = Array<hourData>()
        var tomorrowForecast = Array<hourData>()
        
        let currentDay = forecast.first?.day
        
        for hour in forecast {
            if hour.day == currentDay {
                todayForecast.append(hour)
            }else if hour.day != currentDay {
                tomorrowForecast.append(hour)
            }
        }
        
        return forecastData(today: todayForecast, tomorrow: tomorrowForecast)
    }
    
    func parseCityForRequest(city: String) -> String {
        let cityString = city as NSString
        let cityFormatted = cityString.replacingOccurrences(of: " ", with: "_")
        
        return cityFormatted
    }
}














