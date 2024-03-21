//
//  ChatRoomService.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import Combine
import FirebaseDatabase


protocol ChatRoomServiceType{
    
    func createChatRoomIfNeeded(myUserId: String, friendUserId: String, friendUserName: String) -> AnyPublisher<ChatRoom, ServiceError>
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoom], ServiceError>
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, friendUserId: String, lastMessage: String) -> AnyPublisher<Void, ServiceError>
}

class ChatRoomService: ChatRoomServiceType {
    private let dbRepository: ChatRoomDBRepositoryType
    
    
    init(dbRepository: ChatRoomDBRepositoryType) {
        self.dbRepository = dbRepository
    }
        
    
    func createChatRoomIfNeeded(myUserId: String, friendUserId: String, friendUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
        dbRepository.getChatRoom(myUserId: myUserId, friendUserId: friendUserId)
            .mapError{ ServiceError.error($0) }
            .flatMap { object -> AnyPublisher<ChatRoom, ServiceError> in
                if let object {
                    return Just(object.toModel()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
                } else {
                    let newChatRoom: ChatRoom = .init(chatRoomId: UUID().uuidString, friendUserName: friendUserName, friendUserId: friendUserId)
                    return self.addChatRoom(newChatRoom, to: myUserId)
                }
            }
            .eraseToAnyPublisher()
    }
    func addChatRoom(_ chatRoom: ChatRoom, to myUserId: String) -> AnyPublisher<ChatRoom, ServiceError> {
        dbRepository.addChatRoom(chatRoom.toObject(), myUserId: myUserId)
            .map { chatRoom }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoom], ServiceError> {
        dbRepository.loadChatRooms(myUserId: myUserId)
            .map{ $0.map{ $0.toModel()} }
            .mapError{ .error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, friendUserId: String, lastMessage: String) -> AnyPublisher<Void, ServiceError> {
        
        dbRepository.updateChatRoomLastMessage(chatRoomId: chatRoomId, myUserId: myUserId, myUserName: myUserName, friendUserId: friendUserId, lastMessage: lastMessage)
            .mapError{ ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

class StubChatRoomService: ChatRoomServiceType {
    var value: Any?
    
    func createChatRoomIfNeeded(myUserId: String, friendUserId: String, friendUserName: String) -> AnyPublisher<ChatRoom, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoom], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, friendUserId: String, lastMessage: String) -> AnyPublisher<Void, ServiceError> {
        
        Empty().eraseToAnyPublisher()
    }
}
