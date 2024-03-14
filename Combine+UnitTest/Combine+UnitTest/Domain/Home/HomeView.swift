//
//  HomeView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack(path: $navigationRouter.destination){
            contentView
                .fullScreenCover(item: $homeViewModel.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        MyProfileView(myProfileViewModel: MyProfileViewModel(container: container, userId: homeViewModel.userId))
                    case .friendProfile(let id):
                        FriendProfileView(friendProfileViewModel: FriendProfileViewModel(userId: id, container: container))
                    }
                }
                .navigationDestination(for: NavigationDestination.self) {
                    switch $0 {
                    case .chat :
                        ChatView()
                    case .search:
                        SearchView()
                
                    }
                }
        }        
    }
        
    @ViewBuilder
    var contentView: some View {
        switch homeViewModel.phase {
        case .notRequested:
            PlaceHolderView()
                .onAppear{
                    homeViewModel.send(action: .getUser)
                    homeViewModel.send(action: .loadUser)
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
                .toolbar{
                    ToolbarItemGroup (placement: .topBarTrailing) {
                        HStack(spacing: 0) {
                            Button(action: {
                                
                            }, label: {
                                Image("top_bookmark")
                            }).frame(width:26)
                            
                            Button(action: {
                                
                            }, label: {
                                Image("top_notification")
                            }).frame(width:26)
                            
                            Button(action: {
                                
                            }, label: {
                                Image("top_person_add")
                            }).frame(width:26)
                            
                            Button(action: {
                                
                            }, label: {
                                Image("top_setting")
                            }).frame(width:26)
                            
                        }
                        .frame(height: 30)
                        .padding(.trailing, 20)
                    }
                    
                }
        case .fail:
            ErrorView()
        }
    }
    
    
    var loadedView: some View {
        ScrollView{
            Spacer()
                .frame(height: 16)
            
            profileView
                .padding(.bottom, 30)
            
            searchButton
            
            HStack{
                Text("친구")
                    .font(.system(size: 14))
                    .foregroundColor(.bkText)
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 30)
            .padding(.bottom, 10)
            
            // TODO: 친구 목록
            if homeViewModel.users.isEmpty {
                Spacer(minLength: 89)
                emptyView
                
            }else{
                //화면에 표시할 뷰들을 지연하여 로드하여 효율적으로 처리하기 위한 컨테이너
                //아이템 재사용, 무한 스크롤 가능 영역 = lazyvstack 사용
                LazyVStack{
                    ForEach(homeViewModel.users, id: \.id){ user in
                        Button(action: {
                            homeViewModel.send(action: .presentFriendProfileView(id: user.id))
                        }, label: {
                            HStack (spacing: 8) {
                                let image = user.id.count % 2 != 0 ? "profileSmallPink" : "profileSmallBlue"
                                Image(image)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                Text(user.name ?? "")
                                    .font(.system(size: 12))
                                    .foregroundColor(.bkText)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                        })
                        
                    }
                }
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
            
            URLImageView(urlString: homeViewModel.myUser?.profileImageURL, placeHolderImageName: "profileBigBlue")
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        }
        .padding(.horizontal, 38)
        .onTapGesture {
            homeViewModel.send(action: .presentMyProfileView)
        }
    }
    
    var searchButton: some View {
        
        NavigationLink(value: NavigationDestination.search, label: {
            ZStack{
                Rectangle()
                    .foregroundColor(.greyCool)
                    .frame(height: 36)
                    .cornerRadius(5)
                
                HStack{
                    Text("검색")
                        .font(.system(size: 12))
                        .foregroundColor(.greyDeep)
                    
                    Spacer()
                    
                }.padding(.leading, 22)
                
            }.padding(.horizontal, 30)
        })
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
                homeViewModel.send(action: .requestContacts)
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
    
    HomeView(homeViewModel: .init(container: .init(services: StubService()), navigationRouter: NavigationRouter(), userId: "user1_id"))
        .environmentObject(NavigationRouter())
        .environmentObject(DIContainer(services: Services()))
        
}
