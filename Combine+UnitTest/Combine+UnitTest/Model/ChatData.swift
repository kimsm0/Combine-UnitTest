//
//  ChatData.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import Foundation

struct Chat: Hashable , Identifiable{
    var chatId: String
    var userId: String //message writer
    var message: String?
    var photoURL: String?
    var date: Date    
    var id: String { chatId }
}

//날짜를 기준으로 그룹핑 
struct ChatData: Hashable, Identifiable {
    var id: String { dateStr }
    var dateStr: String
    var chats: [Chat]
}
