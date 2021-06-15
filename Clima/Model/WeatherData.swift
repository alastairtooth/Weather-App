//
//  WeatherData.swift
//  Clima
//
//  Created by Alastair Tooth on 11/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {  //need to advise that this data IS decodable
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double

    // This is required as the temperature is within the 'main' dropdown within the JSON file.  The Struct 'Main' is created so the constant 'main' above can associate with temp, and be listed as it's data type, which is Double.
}

struct Weather: Decodable {
    let description: String
    let id: Int
}


//                  weather[0].description
