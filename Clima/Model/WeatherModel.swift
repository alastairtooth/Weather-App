//
//  WeatherModel.swift
//  Clima
//
//  Created by Alastair Tooth on 11/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    //this struct takes on the converted JSON data from WeatherData.swift from the parseJSON func on WeatherManager, and turns it into content that is usable in the WeatherViewController, via the WeatherManager.swift file
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String { //Computed property - it's value is determined by the inbuilt Switch that utilises an existing Constant (conditionId) to determine it's value.
        switch conditionId {
        case 0...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "Snow"
        case 701...781:
            return "wind"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "questionmark"
        }
    }
    
}
