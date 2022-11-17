//
//  ChangeCityViewController.swift
//  weatherCast
//
//  Created by Kiran Kishore on 06/02/20.
//  Copyright © 2020 CDNS. All rights reserved.
//

import UIKit

protocol SelectedCity {
    func userSelectedCityName(cityName : String)
}

class ChangeCityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    
    var cityDelegate : SelectedCity?
    let cityNames = ["Kochi","Trivandrum","Calicut","Kollam","Kottayam","Thrissur"]

    @IBOutlet weak var userSelectedCity: UITextField!
    @IBOutlet weak var cityPickerView: UIPickerView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cityNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userSelectedCity.text = cityNames[row]
    }
    
    @IBAction func getWeatherOfCity(_ sender: UIButton) {
        cityDelegate?.userSelectedCityName(cityName: userSelectedCity.text!)
        print(userSelectedCity.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
}
