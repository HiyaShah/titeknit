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
    var zipcode: String
    var city: String
    var areaRadius: Double
    var nearestZipsToHome: [String]


    
    init(id: String = "",
         email: String = "",
         username: String = "",
         zipcode: String = "",
         city: String = "",
         areaRadius: Double = Preferences.radius,
         nearestZipsToHome: [String] = [""]) {
        
        self.id = id
        self.email = email
        self.username = username
        self.zipcode = zipcode
        self.city = city
        self.areaRadius = areaRadius
        self.nearestZipsToHome = nearestZipsToHome
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? ""
        username = data["username"] as? String ?? ""
        zipcode = data["zipcode"] as? String ?? ""
        city = data["city"] as? String ?? ""
        areaRadius = data["areaRadius"] as? Double ?? Preferences.radius
        nearestZipsToHome = data["nearestZipsToHome"] as? [String] ?? [""]
        
        
    }
    
    static func modelToData(user: User) -> [String: Any] {
        
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "username" : user.username,
            "zipcode" : user.zipcode,
            "city" : user.city,
            "areaRadius": user.areaRadius,
            "nearestZipsToHome": user.nearestZipsToHome
        ]
        
        return data
    }
}

extension User : Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
