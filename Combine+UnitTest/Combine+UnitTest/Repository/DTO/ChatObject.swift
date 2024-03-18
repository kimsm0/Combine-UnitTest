//
//  ChatObject.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import Foundation

struct ChatObject: Codable {
    var chatId: String
    var userId: String //message writer
    var message: String?
    var photoURL: String?
    var date: Date
    var id: String { chatId }
}

extension ChatObject {
    func toModel() -> Chat{
        .init(chatId: chatId, userId: userId, message: message, photoURL: photoURL, date: date)
    }
}
