//
//  ChatRoomService.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation

protocol ChatRoomServiceType{
    
}

class ChatRoomService: ChatRoomServiceType {
    private let dbRepository: ChatRoomDBRepositoryType
    
    init(dbRepository: ChatRoomDBRepositoryType) {
        self.dbRepository = dbRepository
    }
}

class StubChatRoomService: ChatRoomServiceType{
    
}
