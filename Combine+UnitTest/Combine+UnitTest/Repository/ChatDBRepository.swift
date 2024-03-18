//
//  ChatDBRepository.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatDBRepositoryType{
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError>
    func childByAutoId(chatRoomId: String) -> String
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError>
    func removeObservedHandlers()
}

class ChatDBRepository: ChatDBRepositoryType{

    var db: DatabaseReference = Database.database().reference()
    var observedhandlers: [UInt] = []
    
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError> {
        Just(object) //object -> stream 
            .compactMap{ try? JSONEncoder().encode($0) }
            .compactMap{ try? JSONSerialization.jsonObject(with:$0, options: .fragmentsAllowed)}
            .flatMap{ value in
                Future<Void, Error>{ [weak self] promise in
                    
                    self?.db.child(DBKey.Chats).child(chatRoomId).child(object.chatId).setValue(value) { error, _ in
                        if let error  {
                            promise(.failure(error))
                        }else{
                            promise(.success(()))
                        }
                    }
                }
            }.mapError{ DBError.error($0) }
            .eraseToAnyPublisher()
                
    }
    func childByAutoId(chatRoomId: String) -> String {
        let ref = db.child(DBKey.Chats).child(chatRoomId).childByAutoId()
        return ref.key ?? ""
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError> {
        let subject = PassthroughSubject<Any?, DBError>()
        let handler = db.child(DBKey.Chats).child(chatRoomId).observe(.childAdded){ snapshot in
            subject.send(snapshot.value)
        }
        observedhandlers.append(handler)
        
        return subject.flatMap{ value in
            if let value {
                return Just(value)
                    .tryMap{ try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: ChatObject?.self, decoder: JSONDecoder())
                    .mapError{ DBError.error($0) }
                    .eraseToAnyPublisher()
            }else{
                return Just(nil).setFailureType(to: DBError.self)
                    .eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        observedhandlers.forEach{
            db.removeObserver(withHandle: $0)
        }
    }
}


