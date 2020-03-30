//
//  LocationData.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/29/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation

import Foundation

struct LocationData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: SysCategory
    let coord: Coordinate
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}

struct SysCategory: Codable {
    let country: String
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}
