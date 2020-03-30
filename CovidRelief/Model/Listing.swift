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

    init(
        name: String,
        id: String,
        category: String,
        price: Double,
        isActive: Bool,
        productDescription: String,
        imgUrl: String,
        timeStamp: Timestamp = Timestamp(),
        stock: Int = 0
        ) {
        self.name = name
        self.id = id
        self.category = category
        self.isActive = isActive
        self.listingDescription = productDescription
        self.imgUrl = imgUrl
        self.timeStamp = timeStamp
        self.stock = stock
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
    }
    
    static func modelToData(listing: Listing) -> [String: Any] {
        
        let data : [String: Any] = [
            "name" : listing.name,
            "id" : listing.id,
            "category" : listing.category,
            "productDescription" : listing.listingDescription,
            "isActive": listing.isActive,
            "imgUrl" : listing.imgUrl,
            "timeStamp" : listing.timeStamp,
            "stock" : listing.stock
        ]
        
        return data
    }
}

extension Listing : Equatable {
    static func ==(lhs: Listing, rhs: Listing) -> Bool {
        return lhs.id == rhs.id
    }
}




