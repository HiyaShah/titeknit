//
//  User.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/28/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    var city: String
    var country: String
    var lat: Double
    var lon: Double


    
    init(id: String = "",
         email: String = "",
         username: String = "",
         city: String = "",
         country: String = "",
         lat: Double = 0.0,
         lon: Double = 0.0) {
        
        self.id = id
        self.email = email
        self.username = username
        self.city = city
        self.country = country
        self.lat = lat
        self.lon = lon
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? ""
        username = data["username"] as? String ?? ""
        city = data["city"] as? String ?? ""
        country = data["country"] as? String ?? ""
        lat = data["lat"] as? Double ?? 0.0
        lon = data["lon"] as? Double ?? 0.0
    }
    
    static func modelToData(user: User) -> [String: Any] {
        
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "username" : user.username,
            "city" : user.city
        ]
        
        return data
    }
}

