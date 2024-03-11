//
//  User.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation

struct User {
    var id: String
    var name: String?
    var phoneNumber: String?
    var profileImageURL: String?
    var descriptionText: String?    
}


//친구목록 dummy data

extension User {
    static var stub1: User {
        .init(id: "user1_id", name: "test1")
    }
    
    static var stub2: User {
        .init(id: "user2_id", name: "test2")
    }
}
