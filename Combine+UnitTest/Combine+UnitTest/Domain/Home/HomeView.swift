//
//  HomeView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView{
                profileView
                    .padding(.bottom, 30)
                
                searchButton
                
                HStack{
                    Text("친구")
                        .font(.system(size: 14))
                        .foregroundColor(.bkText)
                    
                    Spacer()
                    
                }.padding(.horizontal, 30)
                    .padding(.top, 30)
                
                // TODO: 친구 목록 
                if homeViewModel.users.isEmpty {
                    Spacer(minLength: 89)
                    
                    emptyView
                }else{
                    ForEach(homeViewModel.users, id: \.id){ user in
                        HStack (spacing: 8) {
                            Image("profileSmallPink")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            Text(user.name ?? "")
                                .font(.system(size: 12))
                                .foregroundColor(.bkText)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                    }
                }
                
            }
            .toolbar{
                Image("top_bookmark")
                Image("top_notification")
                Image("top_person_add")
                Button(action: {
                    
                }, label: {
                    Image("top_setting")
                })
            }
        }
    }
    
    
    var profileView: some View {
        HStack{
            VStack(alignment: .leading, spacing: 7){
                Text("\(homeViewModel.myUser?.name ?? "이름")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.bkText)
                
                Text("\(homeViewModel.myUser?.descriptionText ?? "상태 메시지 입력")")
                    .font(.system(size: 12))
                    .foregroundColor(.greyDeep)
                
            }
            Spacer()
            
            Image("profileBigBlue")
                .resizable()
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        }
        .padding(.horizontal, 38)
    }
    
    var searchButton: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 36)
                .background(Color.greyCool)
                .cornerRadius(5)
            
            HStack{
                Text("검색")
                    .font(.system(size: 12))
                    .foregroundColor(.greyLight)
                
                Spacer()
                
            }.padding(.leading, 22)
            
        }.padding(.horizontal, 30)
        
    }
    
    var emptyView: some View {
        VStack{
            VStack(spacing: 3){
                Text("친구를 추가해보세요.")
                    .foregroundColor(.bkText)
                
                Text("큐알코드나 검색을 이용해서 친구를 추가해보세요.")
                    .foregroundColor(.greyDeep)
                
            }.font(.system(size: 14))
                .padding(.bottom, 30)
            
            Button(action: {
                // TODO:
            }, label: {
                Text("친구 추가")
                    .font(.system(size: 14))
                    .foregroundColor(.bkText)
                    .padding(.vertical, 9)
                    .padding(.horizontal, 24)
            })
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.greyLight)
            }
        }
    }
}

#Preview {
    HomeView(homeViewModel: .init(myUser: nil))
}
