//
//  ChatViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    @Published var chatDataList: [ChatData] = []
    @Published var myUser: User?
    @Published var friendUser: User?
    @Published var message: String = ""
    
    private let chatRoomId: String
    private let myUserId: String
    private let friendUserId: String
    
    private let container: DIContainer
    private var subscription = Set<AnyCancellable>()

    init(chatRoomId: String, myUserId: String, friendUserId: String, container: DIContainer) {
        self.chatRoomId = chatRoomId
        self.myUserId = myUserId
        self.friendUserId = friendUserId
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .load:
            load()
        }
    }
    
    func getDirection(id: String) -> ChatItemDirection{
        myUserId == id ? .right : .left
    }    
}

extension ChatViewModel {
    
    private func load() {
        Publishers.Zip(container.services.userService.getUser(userId: myUserId),
                       container.services.userService.getUser(userId: friendUserId))
        .sink { completion in
            
        } receiveValue: {[weak self] (me, friend) in
            self?.myUser = me
            self?.friendUser = friend
        }.store(in: &subscription)
    }
    
    func updateChatDataList(_ chat: Chat){
        let key = chat.date.convertToString(formatType: nil, formatString: "yyyy.MM.dd E")
        if let chatIndex = chatDataList.firstIndex(where: { $0.dateStr == key }) {
            chatDataList[chatIndex].chats.append(chat)
        }else{
            let newDateChatData: ChatData = .init(dateStr: key, chats: [chat])
            chatDataList.append(newDateChatData)
        }
    }
}
