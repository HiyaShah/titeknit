//
//  DistanceManager.swift
//  ZipcodeApi
//
//  Created by Hiya Shah on 3/31/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation

protocol DistanceManagerDelegate {
    func didUpdateDistance(_ locationManager: DistanceManager, location: DistanceModel)
    func didFailWithError(error: Error)
}

struct DistanceManager {
    let distanceURL =
        //must change to https from http
    "https://www.zipcodeapi.com/rest/s6lAYzFyT525ueMZXgT8AJFB2UmYxUNnu18TGTt4DBisP0gf03VXuwi2SneZ1DB2/radius.json/94566/10/mile"
    
    var delegate: DistanceManagerDelegate?
    
    func fetchNearest(zipcode: String, distance: Double) {
        let urlString = "\(distanceURL)/\(zipcode)/\(distance)/mile"
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
                        self.delegate?.didUpdateDistance(self, location: location)
                    }
                }
            }
            
            //start task
            task.resume()
        }
    }
    
    func parseJSON(_ locationData: Data) -> DistanceModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DistanceData.self, from: locationData)
            let zipcodes = decodedData.zip_codes
            var nearbyZipCodes: [String] = []
            for n in 1...zipcodes.count{
                nearbyZipCodes.append(zipcodes[n-1].zip_code)
            }
            let location = DistanceModel(fullListOfZipCodes: zipcodes, nearbyZips: nearbyZipCodes)
            return location
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
