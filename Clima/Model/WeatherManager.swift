//
//  WeatherManager.swift
//  Clima
//
//  Created by Alastair Tooth on 11/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3d1a1c677b08fe6354c6c035ff1e4154&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //        if the Variable is of a URL data type then...
        if let url = URL(string: urlString) {
            
            //        ...Create a URL session
            let session = URLSession(configuration: .default)
            
            //        Give the session a task - completionHandler is triggered by task once networking complete.  the CH will call in Data, a URL Response, and Error.  all are optional as they may not be received.  WeatherData holds these updated variables for the closure.
            let task = session.dataTask(with: url) { (data, response, error) in //closure statement
                
                //How to handle an error if it's received
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return //This will discontinue the method without looking at the other if statements below
                }
                
                if let safeData = data { //safeData represents the 'data' information received back from the session.dataTask action.
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                        //WORDY EXPLANATION TO HELP CONFIRM HOW THE DELEGATE IS WORKING USING THE PROTOCOLS CREATED
                        //self.delegate is saying that whoever the delegate variable is currently assigned to should run the 'didUpdateWeather' method
                        //self.delegate is an optional as it isn't assigned anywhere until another page (WeatherViewController) sets this variable
                        //WeatherViewController has done this through the following lines of code on it's page
                        
//                            var weatherManager = WeatherManager()
//
//                            override func viewDidLoad() {
//                                super.viewDidLoad()
//                                weatherManager.delegate = self
//                            }
                        
                    }
                }
            } //this is the end of the closure statement here
            
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    

    
}
