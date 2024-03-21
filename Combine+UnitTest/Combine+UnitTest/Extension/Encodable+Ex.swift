//
//  Encodable+Ex.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/21/24.
//

import Foundation

extension Encodable {
    func encode() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dic = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError()
        }
        return dic
    }
}
