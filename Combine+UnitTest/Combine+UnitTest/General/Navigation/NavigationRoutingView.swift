//
//  NavigationRoutingView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case let .chat(chatRoomId, myUserId, friendUserId):
            ChatView(chatViewModel: .init(chatRoomId: chatRoomId, myUserId: myUserId, friendUserId: friendUserId, container: container))
        case .search:
            SearchView()
        }
    }
}

#Preview {
    NavigationRoutingView(destination: .search)
    
}
