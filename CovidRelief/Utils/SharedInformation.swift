//
//  SharedInformation.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/31/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation

struct Preferences {
    static var radius = 5.0
    
    static var nearbyZips: [String] = []
    
    
}


struct CategoryInformation {

    static var listingTypesSupported: [String] = ["---"]
    
//    func appendToListingTypes(type: String){
//        if(!CategoryInformation.listingTypesSupported.contains(type)){
//            CategoryInformation.listingTypesSupported.append(type)
//        }
//    }

}
