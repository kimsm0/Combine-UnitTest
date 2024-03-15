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
    var friendUserName: String
    var friendUserId: String
}

extension ChatRoomObject {
    func toModel() -> ChatRoom {
        .init(chatRoomId: chatRoomId, lastMessage: lastMessage, friendUserName: friendUserName, friendUserId: friendUserId)
    }
}
