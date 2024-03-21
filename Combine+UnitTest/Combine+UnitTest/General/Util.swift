//
//  Util.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/21/24.
//

import Foundation

struct Util {
    
    static func toJson(object: Codable) throws -> Any {
        let encode = try JSONEncoder().encode(object)
        return try JSONSerialization.jsonObject(with: encode, options: .fragmentsAllowed)
    }
}
