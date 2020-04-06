//
//  Wish.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/4/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//
//
//  WishlistType.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/4/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation

import FirebaseFirestore


struct Wish {
    var type: String
    var availableListings: [Listing]
    
    
    init(type: String,
         availableListings: [Listing]) {
            
            self.type = type
            self.availableListings = availableListings
            
        }
        
        init(data: [String: Any]) {
            self.type = data["type"] as? String ?? ""
            self.availableListings = data["availableListings"] as? [Listing] ?? []
            
        }
        
        static func modelToData(wish: Wish) -> [String: Any] {
            let data : [String: Any] = [
                "type" : wish.type,
                "availableListings" : wish.availableListings
            ]
            
            return data
        }
    }



extension Wish : Equatable {
    static func ==(lhs: Wish, rhs: Wish) -> Bool {
        return lhs.type == rhs.type
    }
}
