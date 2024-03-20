//
//  ChatView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import SwiftUI
import PhotosUI

struct ChatView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var chatViewModel: ChatViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollViewReader{ proxy in
            ScrollView {
                if chatViewModel.chatDataList.isEmpty {
                    Color.chatBg2
                }else {
                    contentView
                }
            }
            .onChange(of: chatViewModel.chatDataList.last?.chats) { newValue in
                proxy.scrollTo(newValue?.last?.id, anchor: .bottom)
                
            }
        }
        .background(Color.chatBg2)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(Color.chatBg, for: .navigationBar)
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    container.navigationRouter.pop()
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
                
                PhotosPicker(selection: $chatViewModel.imageSelection,
                             matching: .images) {
                    Image("add_image")
                }
                
                PhotosPicker(selection: $chatViewModel.imageSelection,
                             matching: .images) {
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
                    chatViewModel.send(.addChat(chatViewModel.message))
                    isFocused = false
                } label: {
                    Image("send")
                }
                .disabled(chatViewModel.message.isEmpty)
            }
            .padding(.horizontal, 27)
        }
    }
    
    var contentView: some View {
        ForEach(chatViewModel.chatDataList) { chatData in
            Section(content: {
                ForEach(chatData.chats) { chat in
                    if let message = chat.message {
                        ChatItemView.init(message: message, direction: chatViewModel.getDirection(id: chat.userId), date: chat.date)
                            .id(chat.chatId)
                    }else if let photoURL = chat.photoURL {
                        ChatImageItemView(urlString: photoURL, direction: chatViewModel.getDirection(id: chat.userId))
                            .id(chat.chatId)
                    }
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
