//
//  ChatListView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var chatListViewModel: ChatListViewModel
    
    var body: some View {
        NavigationStack(path: $navigationRouter.destination) {
            ScrollView {
                NavigationLink(value: NavigationDestination.search(userId: chatListViewModel.userId)) {
                    SearchButtonView()
                }
                .padding(.top, 14)
                .padding(.bottom, 14)
                
                ForEach(chatListViewModel.chatRooms, id: \.self) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, userId: chatListViewModel.userId)
                }
            }
            .navigationTitle("대화")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
            .onAppear{
                chatListViewModel.send(action: .loadChatRooms)
            }
        }
    }
}


fileprivate struct ChatRoomCell: View {
    var chatRoom: ChatRoom
    var userId: String
    
    var body: some View{
        NavigationLink(value: NavigationDestination.chat(chatRoomId: chatRoom.chatRoomId,
                                                         myUserId: userId,
                                                         friendUserId: chatRoom.friendUserId)){
            HStack(spacing: 8){
                Image("profileSmallBlue")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                VStack (alignment: .leading, spacing: 3){
                    Text(chatRoom.friendUserName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.bkText)
                    
                    if let lastMessage = chatRoom.lastMessage {
                        Text(lastMessage)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.greyDeep)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    ChatListView(chatListViewModel: ChatListViewModel(container: .init(services: StubService()), userId: "test_userId"))
        .environmentObject(NavigationRouter())
}
