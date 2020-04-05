////
////  Level.swift
////  CovidRelief
////
////  Created by Hiya Shah on 4/4/20.
////  Copyright © 2020 Hiya Shah. All rights reserved.
////
//
//import Foundation
//
//struct Level {
//    var num: Int
//    var id: String
//    var tasks: [Task]
//
//    init(
//        num: Int,
//        id: String,
//        tasks: [Task]
//        ) {
//        self.num = num
//        self.id = id
//        self.tasks = tasks
//    }
//
//    init(data: [String: Any]) {
//        num = data["num"] as? Int ?? 1
//        id = data["id"] as? String ?? ""
//        tasks = data["tasks"] as? [Task] ?? []
//
//    }
//
//    static func modelToData(level: Level) -> [String: Any] {
//
//        let data : [String: Any] = [
//            "num" : level.num,
//            "id": listing.username,
//            "email": listing.email,
//            "id" : listing.id,
//            "category" : listing.category,
//            "productDescription" : listing.listingDescription,
//            "isActive": listing.isActive,
//            "imgUrl" : listing.imgUrl,
//            "timeStamp" : listing.timeStamp,
//            "stock" : listing.stock,
//            "city": listing.city,
//            "zip": listing.zip,
//            "type": listing.type
//        ]
//
//        return data
//    }
//
//    func getZip() -> String {
//        return self.zip
//    }
//}
//
//extension Level: Equatable {
//    static func == (lhs: Level, rhs: Level) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
//
//struct Task {
//    var todo: String
//    var count: Int
//}
//
//
