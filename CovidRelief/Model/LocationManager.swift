//
//  LocationManager.swift
//  ZipcodeApi
//
//  Created by Hiya Shah on 3/30/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation

protocol LocationManagerDelegate {
    func didUpdateLocation(_ locationManager: LocationManager, location: LocationModel)
    func didFailWithError(error: Error)
}

struct LocationManager {
    let locationURL =
        //must change to https from http
    "https://www.zipcodeapi.com/rest/lm9IzBEU6VprWrk7SEO9OAmVMnF1HJlCAbrqQqtH0zEn2nsQEiCCv7IFLL1sJtqY/info.json"
    
    var delegate: LocationManagerDelegate?
    
    func fetchCity(zipcode: String) {
        let urlString = "\(locationURL)/\(zipcode)/degrees"
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
                    if let location = self.parseJSON(safeData) {
                        self.delegate?.didUpdateLocation(self, location: location)
                    }
                }
            }
            
            //start task
            task.resume()
        }
    }
    
    func parseJSON(_ locationData: Data) -> LocationModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LocationData.self, from: locationData)
            let city = decodedData.city
            let zipcode = decodedData.zip_code
            
            let weather = LocationModel(zipcode: zipcode, cityName: city)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


