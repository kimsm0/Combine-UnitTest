//
//  ChatListViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import Foundation
import Combine

class ChatListViewModel: ObservableObject {
    enum Action{
        case loadChatRooms
    }
    
    @Published var chatRooms: [ChatRoom] = []
    
    private var container: DIContainer
    var userId: String
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action){
        switch action {
        case .loadChatRooms:
            container.services.chatRoomService.loadChatRooms(myUserId: userId)
                .sink { completion in
                    
                } receiveValue: {[weak self] rooms in
                    self?.chatRooms = rooms
                }.store(in: &subscriptions)

        }
    }
}

