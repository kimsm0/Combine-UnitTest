//
//  ChatRoomDBRepository.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatRoomDBRepositoryType {
    func getChatRoom(myUserId: String, friendUserId: String) -> AnyPublisher<ChatRoomObject?, DBError>
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError>
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError>
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, friendUserId: String, lastMessage: String) -> AnyPublisher<Void, DBError>
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
    
    private let dbReference: DBReferenceType
    
    init(dbReference: DBReferenceType) {
        self.dbReference = dbReference
    }
    
    func getChatRoom(myUserId: String, friendUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
        
        dbReference.fetch(key: DBKey.ChatRooms, path: "\(myUserId)/\(friendUserId)")
            .flatMap{ value in
                if let value {
                    return Just(value)
                        .tryMap{ try JSONSerialization.data(withJSONObject: $0)}
                        .decode(type: ChatRoomObject?.self, decoder: JSONDecoder())
                        .mapError{_ in  DBError.decodingError }
                        .eraseToAnyPublisher()
                }else {
                    return Just(nil)
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
        
        Just(object)
            .tryMap{ try Util.toJson(object: $0) }
            .mapError{_ in  DBError.encodingError }
            .flatMap{[weak self] value in
                guard let weakSelf = self else {
                    return Empty<Void, DBError>().eraseToAnyPublisher()
                        .eraseToAnyPublisher()
                }
                return weakSelf.dbReference.setValue(key: DBKey.ChatRooms, path: "\(myUserId)/\(object.friendUserId)", value: value)
            }.eraseToAnyPublisher()
    }
    
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError> {
        dbReference.fetch(key: DBKey.ChatRooms, path: myUserId)
            .flatMap{ value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap{ try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: ChatRoomObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as ChatRoomObject } }
                        .mapError{ DBError.error($0) }
                        .eraseToAnyPublisher()
                }else if value == nil {
                    return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
                }else{
                    return Fail(error: DBError.invalidate).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, friendUserId: String, lastMessage: String) -> AnyPublisher<Void, DBError> {
        let values = [
            "\(DBKey.ChatRooms)/\(myUserId)/\(friendUserId)/lastMessage" : lastMessage,
            "\(DBKey.ChatRooms)/\(friendUserId)/\(myUserId)/lastMessage" : lastMessage,
            "\(DBKey.ChatRooms)/\(friendUserId)/\(myUserId)/chatRoomId" : chatRoomId,
            "\(DBKey.ChatRooms)/\(friendUserId)/\(myUserId)/friendUserName" : myUserName,
            "\(DBKey.ChatRooms)/\(friendUserId)/\(myUserId)/friendUserId" : myUserId
        ]
        return dbReference.setValues(values)
    }
}


class MockChatRoomDBRepository: ChatRoomDBRepositoryType {
    
    let mockData: Any?
    
    var addChatRoomCallCount = 0
    var getChatRoomCallCount = 0
    
    init(mockData: Any?) {
        self.mockData = mockData
    }
    
    func getChatRoom(myUserId: String, friendUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
        getChatRoomCallCount += 1
        return Just(mockData as? ChatRoomObject).setFailureType(to: DBError.self)
            .eraseToAnyPublisher()
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
        addChatRoomCallCount += 1
        return Just(()).setFailureType(to: DBError.self)
            .eraseToAnyPublisher()
    }
    
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError> {
        if let value = mockData as? ChatRoomObject {
            return Just([value]).setFailureType(to: DBError.self)
                .eraseToAnyPublisher()
        }else{
            return Just([]).setFailureType(to: DBError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, friendUserId: String, lastMessage: String) -> AnyPublisher<Void, DBError> {
        return Just(()).setFailureType(to: DBError.self)
            .eraseToAnyPublisher()
    }
}
