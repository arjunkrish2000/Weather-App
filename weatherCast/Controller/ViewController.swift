//
//  ViewController.swift
//  weatherCast
//
//  Created by Kiran Kishore on 06/02/20.
//  Copyright © 2020 CDNS. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import SVProgressHUD

class ViewController: UIViewController , CLLocationManagerDelegate, SelectedCity{
    
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    let appID = "21232d2acb534a8e67718d8b651b0f8b"
    
    let locationManager = CLLocationManager()           //Object of 'CLLocationManager' to access location data
    let weatherDataManager = WeatherDataModel()         //Object of 'WeatherDataModel' class
    
    
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var weatherIconImg: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:  Location manager setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: Networking method getWeatherData()
    func getWeatherData(url: String, parameters: [String: String]){
        
        Alamofire.request(weatherURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("Successfully recieved weather data!")
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                self.updateWeatherData(jsonData: weatherJSON)
                
            }else{
                print("Error \(String(describing: response.result.error))")
                print("Error\(String(describing: response.result.error))")
                self.cityNameLbl.text = "Connection Issues"
                
//                let alert = UIAlertController(title: "Connection Issues", message: "", preferredStyle: .alert)
//                present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    //MARK: Location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            //SVProgressHUD.dismiss()
            self.locationManager.stopUpdatingLocation()
            print("Location Data Fetched.\nLatitude : \(location.coordinate.latitude)\nLongitude : \(location.coordinate.longitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String:String] = ["lat" : latitude, "lon" : longitude, "appid" : appID]
            
            getWeatherData(url: weatherURL, parameters: params)
        }else{
            //SVProgressHUD.dismiss()
            
            print("Invalid Location")
            
//            let alert = UIAlertController(title: "Invalid Location", message: "", preferredStyle: .alert)
//            present(alert, animated: true, completion: nil)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityNameLbl.text = "Location Unavailable"
//        let alert = UIAlertController(title: "Location Unavailable", message: "", preferredStyle: .alert)
//        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Update weather data method
    func updateWeatherData(jsonData : JSON){
        let temperatureData = jsonData["main"]["temp"].doubleValue
        
        weatherDataManager.temperature = Int(temperatureData - 273.15)
        weatherDataManager.city = jsonData["name"].stringValue
        weatherDataManager.condition = jsonData["weather"][0]["id"].intValue
        weatherDataManager.weatherIconName = weatherDataManager.updateWeatherIcon(condition: weatherDataManager.condition)
        
        updateWeatherCastUI()
    }
    
    //MARK: Update the UI with weather data
    func updateWeatherCastUI(){
        //SVProgressHUD.dismiss()
        cityNameLbl.text = weatherDataManager.city
        temperatureLbl.text = String(weatherDataManager.temperature)+"°C" //degree celcius symbol ->(option+shift+8)
        weatherIconImg.image = UIImage(named: weatherDataManager.weatherIconName)
    }
    
    @IBAction func searchByCityBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCitySelection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCitySelection"{
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.cityDelegate = self
        }
        
    }
    //MARK: Protocol method
    func userSelectedCityName(cityName: String) {
        print("Data recieved")
        
        let params = ["q" : cityName, "appid" : appID]
        getWeatherData(url: weatherURL, parameters: params)
    }
    
    
    
}
