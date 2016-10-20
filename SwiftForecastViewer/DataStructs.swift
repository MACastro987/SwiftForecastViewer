//
//  ParsingModel.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/7/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import Foundation

struct currentDisplayData {
    let english: String
    let metric: String
    let cityAndState: String
    let weather: String
}

struct hourData {
    let day: String
    let time: String
    let temp: String
    let icon: URL
}

struct forecastData {
    let today: Array<hourData>
    let tomorrow: Array<hourData>
}
