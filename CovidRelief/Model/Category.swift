//
//  Category.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/23/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation
import FirebaseFirestore


struct Category {
    var name: String
    var id: String
    var isActive: Bool = true
    var timeStamp: Timestamp
    var count: Int = 0 //add to it everytime document created to count it
    var listingNamesSupported: [String]
    
    init(
            name: String,
            id: String,
            count: Int,
            isActive: Bool = true,
            timeStamp: Timestamp,
            listingNamesSupported: [String]) {
            
            self.name = name
            self.id = id
            self.count = count
            self.isActive = isActive
            self.timeStamp = timeStamp
            self.listingNamesSupported = listingNamesSupported
            for item in self.listingNamesSupported {
                if(!CategoryInformation.listingTypesSupported.contains(item)){
                    CategoryInformation.listingTypesSupported.append(item)
                }
            }
        }
        
        init(data: [String: Any]) {
            self.name = data["name"] as? String ?? ""
            self.id = data["id"] as? String ?? ""
            self.count = data["count"] as? Int ?? 0
            self.isActive = data["isActive"] as? Bool ?? true
            self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
            self.listingNamesSupported = data["listingNamesSupported"] as? [String] ?? ["Other"]
            for item in self.listingNamesSupported {
                if(!CategoryInformation.listingTypesSupported.contains(item)){
                    CategoryInformation.listingTypesSupported.append(item)
                }
            }
        }
        
        static func modelToData(category: Category) -> [String: Any] {
            let data : [String: Any] = [
                "name" : category.name,
                "id" : category.id,
                "count" : category.count,
                "isActive" : category.isActive,
                "timeStamp" : category.timeStamp,
                "listingNamesSupported": category.listingNamesSupported
            ]
            
            return data
        }
    }


