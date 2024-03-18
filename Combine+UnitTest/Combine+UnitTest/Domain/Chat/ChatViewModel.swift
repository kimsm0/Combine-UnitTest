//
//  ChatViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI

class ChatViewModel: ObservableObject {
    
    enum Action {
        case load
        case addChat(String)
        case uploadImage(PhotosPickerItem?)
    }
    
    @Published var chatDataList: [ChatData] = []
    @Published var myUser: User?
    @Published var friendUser: User?
    @Published var message: String = ""
    @Published var imageSelection: PhotosPickerItem?{
        didSet{
            send(.uploadImage(imageSelection))
        }
    }
    
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
        
        bind()
    }
    
    func bind(){
        container.services.chatService.observeChat(chatRoomId: chatRoomId)
            .sink { [weak self] chat in
                guard let chat else { return }
                self?.updateChatDataList(chat)
            }.store(in: &subscription)
    }
    
    func send(_ action: Action) {
        switch action {
        case .load:
            load()
        case let .addChat(message):
            addChat(message: message)
        case let .uploadImage(image):
            uploadImage(image: image)
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
    
    func addChat(message: String){
        let newChat = Chat.init(chatId: UUID().uuidString, userId: myUserId,message: message, date: Date())
        
        container.services.chatService.addChat(newChat, to: chatRoomId)
            .flatMap{ chat in
                self.container.services.chatRoomService.updateChatRoomLastMessage(chatRoomId: self.chatRoomId,
                                                                                  myUserId: self.myUserId,
                                                                                  myUserName: self.myUser?.name ?? "",
                                                                                  friendUserId: self.friendUserId,
                                                                                  lastMessage: chat.lastMessage)
            }
            .sink { completion in
                
            } receiveValue: {[weak self] chat in
                self?.message = ""
            }.store(in: &subscription)
    }
    
    func uploadImage(image: PhotosPickerItem?) {
        //image -> data
        //uploadservice
        //url
        //chat > url add
        guard let image else { return }
        container.services.photoPickerService.loadTransferable(from: image)
            .flatMap{ data in
                self.container.services.uploadService.uploadImage(source: .chat(chatRoomId: self.chatRoomId), data: data)
            }.flatMap{ url in
                let chat: Chat = .init(chatId: UUID().uuidString, userId: self.myUserId, photoURL: url.absoluteString, date: Date())
                return self.container.services.chatService.addChat(chat, to: self.chatRoomId)
            }
            .flatMap{ chat in
                
                self.container.services.chatRoomService.updateChatRoomLastMessage(chatRoomId: self.chatRoomId,
                                                                                  myUserId: self.myUserId,
                                                                                  myUserName: self.myUser?.name ?? "",
                                                                                  friendUserId: self.friendUserId,
                                                                                  lastMessage: chat.lastMessage)                
            }
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: {_ in
                
            })
            .store(in: &subscription)
        
    }
    
}

