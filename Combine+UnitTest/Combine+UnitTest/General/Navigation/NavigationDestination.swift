//
//  NavigationDestination.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, friendUserId: String)
    case search
}
