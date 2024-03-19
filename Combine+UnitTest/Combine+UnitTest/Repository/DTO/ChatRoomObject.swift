/**
 @class ChatRoomObject
 @date 3/13/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
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
