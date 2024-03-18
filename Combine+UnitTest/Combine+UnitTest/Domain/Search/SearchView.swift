//
//  SearchView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack{
            topView
            
            List{
                ForEach(searchViewModel.searchUsers) { user in
                    HStack(spacing: 8) {
                        URLImageView(urlString: user.profileImageURL, placeHolderImageName: nil)
                            .frame(width: 26, height: 26)
                            .clipShape(Circle())
                                                
                        Text(user.name ?? "")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.bkText)
                            
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, 30)
                }
            }
            .listStyle(.plain)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        
    }
    
    var topView: some View {
        HStack(spacing: 0){
            Button(action: {
                navigationRouter.pop()
            }, label: {
                Image("search_back")
            })
            
            SearchBar(text: $searchViewModel.searchText,
                      shouldBecomeFirstResponde: $searchViewModel.shouldBecomeFirstResponder)
            
            Button(action: {
                searchViewModel.send(.clearSearchText)
            }, label: {
                Image("search_close")
            })
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SearchView(searchViewModel: .init(container: DIContainer(services: StubService()), userId: "testUserId"))
    
//    NavigationStack{
//        SearchView(viewModel: .init(container: DIContainer(services: StubService()), userId: "testUserId"))
//    }
//    .searchable(text: .constant("oo"))
}
