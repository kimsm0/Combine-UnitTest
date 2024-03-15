//
//  ChatView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var chatViewModel: ChatViewModel
    @FocusState private var isFocused: Bool
    var body: some View {
        ScrollView {
            if chatViewModel.chatDataList.isEmpty {
                Color.chatBg2
            }else {
                contentView
            }
        }
        .background(Color.chatBg2)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(Color.chatBg, for: .navigationBar)
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    navigationRouter.pop()
                }, label: {
                    Image("back")
                })
                
                Text(chatViewModel.friendUser?.name ?? "대화방 이름")
                    .font(.system(size:20, weight: .bold))
                    .foregroundColor(.bkText)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Image("top_search_chat")
                Image("top_bookmark")
                Image("top_setting")
            }
        }
        .keyboardToolbar(height: 50){
            HStack(spacing: 13) {
                Button {
                    
                } label: {
                    Image("add_other")
                }
                               
                Button {
                    
                } label: {
                    Image("add_image")
                }
                
                Button {
                    
                } label: {
                    Image("add_camera")
                }
                
                TextField("", text: $chatViewModel.message)
                    .font(.system(size: 16))
                    .foregroundColor(.bkText)
                    .focused($isFocused)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(.greyCool)
                    .cornerRadius(20)
                
                Button {
                    
                } label: {
                    Image("send")
                }
            }
            .padding(.horizontal, 27)
        }
    }
    
    var contentView: some View {
        ForEach(chatViewModel.chatDataList) { chatData in
            Section(content: {
                ForEach(chatData.chats) { chat in
                    ChatItemView.init(message: chat.chatId, direction: chatViewModel.getDirection(id: chat.id), date: chat.date)
                }
            }, header: {
                headerView(dateString: chatData.dateStr)
            })
        }
    }
    
    func headerView(dateString: String) -> some View{
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 76, height:  20)
                .background(Color.chatNotice)
                .cornerRadius(50)
            Text(dateString)
                .font(.system(size: 10))
                .foregroundStyle(.whiteFix)
        }
        //.padding(.top, 10)
    }
}

#Preview {
    NavigationStack {
        ChatView(chatViewModel: .init(chatRoomId: "testChatRoomId",
                                      myUserId: "testUserId1",
                                      friendUserId: "testUserId2",
                                      container: .init(services: StubService())))
    }
}
