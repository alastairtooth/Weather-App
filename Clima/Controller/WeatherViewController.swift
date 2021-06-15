//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    //locationManager initialises a request to the user to access their location.  To amend the onscreen message, click into the info.plist file, add a 'Privacy - ' permission, and add an appropriate comment in the 'Value' column

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self //IMPORTANT: this line needs to happen before the next two lines to work
        locationManager.requestWhenInUseAuthorization() //request location message on screen
        locationManager.requestLocation() //Once approved, this requests the locations - it calls the 'didupdatelocations' functions below
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        
        // The above searchtextfield.delegate delegates the viewcontroller as being in charge of what happens with the UITextField (i.e. it tells the UIViewController what it's doing and then the UIViewController makes judgement calls based off pre-set rules - like putting a keyboard away once someone clicks out of the UITextField.  Need to addthe UITextFieldDelegate bit at the top too.  The weatherManager.delegate is tells WeatherManager Struct in WeatherManager.Swift that the WeatherViewController is an acceptable delegate, as per the created protocols.
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()

    }
    
}

//The below 'Mark' line makes a comment interact with the page of code, and creates as section-break in the .swift file that is viewable in the documents, and in the dropdown above  The mark comment was created as a Snippet by highlighting the '//MORK: - ' (change the O to an A) text, right clicking and pressing 'Create code snippet'.  To make the field where the text needed to be added you write <#whatevertextyouwant# > - the second space was so it wouldn't turn into one.

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    //This extension of the WeatherViewController (WVC) is in charge of the UITextFieldDelegate properties.  It has been split out from the WVC class to make the code easier to read, and the use of 'Extension' allows it to continue on the WVC and add in additional content (i.e. - the below methods)
    
        @IBAction func searchPressed(_ sender: UIButton) {
            searchTextField.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            //Code that runs once person presses 'return' on keyboard.
            searchTextField.endEditing(true)
    //        UITextField
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != "" {
                return true
            } else {
                textField.placeholder = "Type Something"
                return false
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if let city = searchTextField.text {
                weatherManager.fetchWeather(cityName: city)
    //            conditionImageView.image = imageIcon
            }
            
            searchTextField.text = ""
            //Removes text from textfield once completed
        }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    //As per the above, this extension further extends the functionality of the MVC Class through the WeatherManagerDelegate
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
       
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName) //replaces the image on the UI with the updated image name
            self.cityLabel.text = weather.cityName
            print(weather.conditionName)
            print(weather.conditionId)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last { // this is an if/let statement that says 'create 'location' property if you can find the last 'locations' coordinates
            locationManager.stopUpdatingLocation() //This needs to be added so it stops looking for a location once one has been found.  It allows the current location button to work.
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
   
    }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    



}
