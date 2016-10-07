//
//  CurrentWeatherParser.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/6/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import Foundation

class CurrentWeatherParser {
    
    let units = 0   // if units 0 then Fahrenheight, if unit 1 then Celsius
    
    func currentFrom(json: [String: Any]?) -> CurrentCondition? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        guard let st = observe["station_id"] as? String else { return nil }
        guard let we = observe["weather"] as? String else { return nil }
        guard let hu = observe["relative_humidity"] as? String else { return nil }
        
        let keyP = units == 0 ? "pressure_in" : "pressure_mb"
        guard let pr = observe[keyP] as? String else { return nil }
        
        guard let pt = observe["pressure_trend"] as? String else { return nil }
        
        let keyV = units == 0 ? "visibility_mi" : "visibility_km"
        guard let vi = observe[keyV] as? String else { return nil }
        
        guard let uv = observe["UV"] as? String else { return nil }
        guard let ic = observe["icon"] as? String else { return nil }
        
        return CurrentCondition(stationId: st, weather: we, humidity: hu, pressure: pr, presstrend: pt, visibility: vi, uv: uv, icon: ic)
    }
    
    func currentLocationFrom(json: [String: Any]?) -> CurrentLocation? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        guard let location = observe["display_location"] as? [String: Any] else { return nil }
        
        guard let full = location["full"] as? String else { return nil }
        guard let city = location["city"] as? String else { return nil }
        guard let st = location["state"] as? String else { return nil }
        guard let zip = location["zip"] as? String else { return nil }
        guard let lat = location["latitude"] as? String else { return nil }
        guard let lon = location["longitude"] as? String else { return nil }
        guard let elev = location["elevation"] as? String else { return nil }
        
        return CurrentLocation(full: full, city: city, state: st, zip: zip, lat: lat, lon: lon, elevation: elev)
    }
}
