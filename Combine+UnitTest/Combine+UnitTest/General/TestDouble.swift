//
//  TestDouble.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/21/24.
//

import Foundation


struct TestDouble {
    
    static func getString(_ with: Int, key: String) -> String{
        return "test_\(key)_\(with)"
    }
     
    
    static func getUserObject(_ with: Int) -> UserObject {
        .init(id: getString(with, key: "id"),
              name: getString(with, key: "name"),
        phoneNumber: getString(with, key: "phoneNumber"),
        profileImageURL: getString(with, key: "profileImageURL"),
        descriptionText: getString(with, key: "descriptionText"))
    }
    
    static func getUserDictionary(_ with: Int) -> [String: Any] {
        do {
            let dic = try getUserObject(with).encode()
            return dic
        }catch {
            return [:]
        }
    }
    
    static func getChatRoomObject(_ with: Int) -> ChatRoomObject {
        
        .init(chatRoomId: getString(with, key: "chatRoomId"),
              lastMessage: getString(with, key: "lastMessage"),
              friendUserName: getString(with, key: "friendUserName"),
              friendUserId: getString(with, key: "friendUserId"))
    }
    
    
    static func getChatRoomDictionary(_ with: Int) -> [String: Any] {
        do {
            let dic = try getChatRoomObject(with).encode()
            return dic
        }catch {
            return [:]
        }
    }
    
}
