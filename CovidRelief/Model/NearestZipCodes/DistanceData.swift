//
//  DistanceData.swift
//  ZipcodeApi
//
//  Created by Hiya Shah on 3/31/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation

struct DistanceData:  Codable {
    let zip_codes: [ZipCodes]
}

struct ZipCodes: Codable {
    let zip_code: String
}


