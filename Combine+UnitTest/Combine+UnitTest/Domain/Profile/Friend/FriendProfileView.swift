//
//  FriendProfileView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct FriendProfileView: View {
    @StateObject var friendProfileViewModel: FriendProfileViewModel
    @Environment(\.dismiss) var dismiss
    var goToChat: (User) -> Void
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                                        
                VStack{
                    Spacer()
                    friendProfileView
                    Spacer()
                    bottomIconView
                }
            }.toolbar{
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("close")
                    })
                })
            }
        }.task {
            friendProfileViewModel.send(.loadUser)
        }
        
    }
    
    var friendProfileView: some View {
        VStack{
            URLImageView(urlString: "", placeHolderImageName: "profileBigBlue")
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            Spacer()
                .frame(height: 16)
            Text(friendProfileViewModel.user?.name ?? "이름")
                .font(.system(size: 24))
                .foregroundColor(.whiteFix)
        }
        
    }
    
    var bottomIconView: some View {
        HStack(spacing: 30){
            ForEach(FriendProfileMenuType.allCases, id: \.self) { menu in
                
                VStack(spacing: 0) {
                    Button(action: {
                        // TODO:
                        if menu == .chat, let friend = friendProfileViewModel.user {
                            dismiss()
                            goToChat(friend)
                        }
                    }, label: {
                        VStack{
                            Image(menu.iconImageName)
                                .frame(width: 50, height: 50)
                            
                            Text(menu.description)
                                .font(.system(size: 12))
                                .foregroundColor(.whiteFix)
                        }
                    })
                }
                .padding(.bottom, 58)
            }
        }
    }
}

#Preview {
    FriendProfileView(friendProfileViewModel: .init(userId: "test_userId", container: .init(services: StubService()))) { _ in
        
    }
        
}
