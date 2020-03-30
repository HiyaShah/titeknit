//
//  LocationViewController.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/29/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import CoreLocation


class LocationViewController: UIViewController {


    
    var weatherManager =  LocationManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //startupdatinglocation is for continuous
        
        
        weatherManager.delegate = self
    }
    
    @IBAction func homeBtnClicked(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    
}

//MARK: - UITextFieldDelegate



    
    

//MARK: - WeatherManagerDelegate

extension LocationViewController: LocationManagerDelegate {
    func didUpdateWeather(_ weatherManager: LocationManager, weather: LocationModel) {
        DispatchQueue.main.async {
            UserService.user.city = weather.cityName
            UserService.user.country = weather.countryName
            UserService.user.lat = weather.latitude
            UserService.user.lon = weather.longitude
        }
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchLocation(latitude: lat, longitude: lon)
            
        }
    }
    
    func getDistanceInKmGivenLonLat(lat1: Double, lat2: Double, lon1: Double, lon2: Double) -> Double {
        let R = 6371e3; // metres
        let φ1 = lat1.toRadians();
        let φ2 = lat2.toRadians();
        let Δφ = (lat2-lat1).toRadians();
        let Δλ = (lon2-lon1).toRadians();

        let a = sin(Δφ/2) * sin(Δφ/2) +
                cos(φ1) * cos(φ2) *
                sin(Δλ/2) * sin(Δλ/2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));

        let d = R * c;
        return d
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

