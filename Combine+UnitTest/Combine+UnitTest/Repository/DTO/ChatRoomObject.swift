//
//  ChatRoomObject.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation

struct ChatRoomObject: Codable {
    var chatRoomId: String
    var lastMessage: String?
    var otherUserName: String
    var otherUseId: String
}
