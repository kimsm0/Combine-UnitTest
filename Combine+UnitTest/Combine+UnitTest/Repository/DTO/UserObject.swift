//
//  UserObject.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation

struct UserObject: Codable {
    var id: String
    var name: String?
    var phoneNumber: String?
    var profileImageURL: String?
    var descriptionText: String?
}

extension UserObject {
    func toModel() -> User {
        .init(id: id, name: name, phoneNumber: phoneNumber, profileImageURL: profileImageURL, descriptionText: descriptionText)
    }
}
