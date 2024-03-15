//
//  ChatRoom.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import Foundation

struct ChatRoom: Hashable {
    var chatRoomId: String
    var lastMessage: String?
    var friendUserName: String
    var friendUserId: String
}
extension ChatRoom {
    func toObject() -> ChatRoomObject {
        .init(chatRoomId: chatRoomId, lastMessage: lastMessage, friendUserName: friendUserName, friendUserId: friendUserId)
    }
}

extension ChatRoom {
    static var stub1: ChatRoom {
        .init(chatRoomId: "testChatRoomId_1", friendUserName: "testfriendUserName_1", friendUserId: "testfriendUserId_1")
    }
    
    static var stub2: ChatRoom {
        .init(chatRoomId: "testChatRoomId_2", friendUserName: "testfriendUserName_2", friendUserId: "testfriendUserId_2")
    }
}
