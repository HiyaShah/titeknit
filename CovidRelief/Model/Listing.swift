//
//  Listing.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/23/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation
import FirebaseFirestore
import UIKit
import CoreLocation
import AddressBook
import AddressBookUI
import MapKit
import Contacts


struct Listing {
    var name: String
    var id: String
    var imgUrl: String
    var category: String
    var isActive: Bool = true
    var listingDescription: String
    var timeStamp: Timestamp
    var stock: Int
    var username: String
    var email: String
    var city: String
    var zip: String
    var type: String

    init(
        name: String,
        id: String,
        category: String,
        price: Double,
        isActive: Bool,
        listingDescription: String,
        imgUrl: String,
        timeStamp: Timestamp = Timestamp(),
        stock: Int,
        username: String,
        email: String,
        city: String,
        zip: String,
        type: String
        ) {
        self.name = name
        self.id = id
        self.category = category
        self.isActive = isActive
        self.listingDescription = listingDescription
        self.imgUrl = imgUrl
        self.timeStamp = timeStamp
        self.stock = stock
        self.city = city
        self.username = username
        self.email = email
        self.zip = zip
        self.type = type
    }
    
    init(data: [String: Any]) {
        name = data["name"] as? String ?? ""
        id = data["id"] as? String ?? ""
        category = data["category"] as? String ?? ""
        listingDescription = data["listingDescription"] as? String ?? ""
        isActive = data["isActive"] as? Bool ?? true
        imgUrl = data["imgUrl"] as? String ?? ""
        timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        stock = data["stock"] as? Int ?? 0
        city = data["city"] as? String ?? ""
        username = data["username"] as? String ?? ""
        email = data["email"] as? String ?? ""
        zip = data["zip"] as? String ?? ""
        type = data["type"] as? String ?? ""
    }
    
    static func modelToData(listing: Listing) -> [String: Any] {
        
        let data : [String: Any] = [
            "name" : listing.name,
            "username": listing.username,
            "email": listing.email,
            "id" : listing.id,
            "category" : listing.category,
            "listingDescription" : listing.listingDescription,
            "isActive": listing.isActive,
            "imgUrl" : listing.imgUrl,
            "timeStamp" : listing.timeStamp,
            "stock" : listing.stock,
            "city": listing.city,
            "zip": listing.zip,
            "type": listing.type
        ]
        
        return data
    }
    
    func getZip() -> String {
        return self.zip
    }
}

extension Listing : Equatable {
    static func ==(lhs: Listing, rhs: Listing) -> Bool {
        return lhs.id == rhs.id
    }
}




