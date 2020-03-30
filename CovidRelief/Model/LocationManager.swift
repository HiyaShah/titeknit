//
//  LocationManager.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/29/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate {
    func didUpdateWeather(_ weatherManager: LocationManager, weather: LocationModel)
    func didFailWithError(error: Error)
}

struct LocationManager {
    let weatherURL =
        //must change to https from http
    "https://api.openweathermap.org/data/2.5/weather?appid=c77d7597600464fc1146c28a986ac945"
    
    var delegate: LocationManagerDelegate?
    
    func fetchLocation(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //make url
        if let url = URL(string: urlString) {
            //make url session
            let session = URLSession(configuration: .default)
            //give task
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //start task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> LocationModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LocationData.self, from: weatherData)
            let country = decodedData.sys.country
            let name = decodedData.name
            let lon = decodedData.coord.lon
            let lat = decodedData.coord.lat
            UserService.user.city = name
            UserService.user.country = country
            UserService.user.lon = lon
            UserService.user.lat = lat

            let weather = LocationModel(latitude: lat, longitude: lon, cityName: name, countryName: country)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}

