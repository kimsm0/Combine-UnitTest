//
//  Constant.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation


typealias DBKey = Constant.DBKey

enum Constant {}

extension Constant {
    struct DBKey{
        static let Users = "Users"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
    }
}

