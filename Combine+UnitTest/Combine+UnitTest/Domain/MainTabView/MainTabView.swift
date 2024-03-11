//
//  MainTabView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        
        TabView(selection: $selectedTab,
                content:  {
            
                ForEach(MainTabType.allCases, id:\.self, content: { tab in
                    Group{
                        switch tab {
                        case .home:
                            HomeView(homeViewModel: .init(myUser: nil))
                        case .chat:
                            ChatListView()
                        case .phone:
                            ChatListView()
                        }
                    }.tabItem {
                        Label(tab.titlle, image: tab.imageName(selected: tab == selectedTab))
                    }
                    .tag(tab)
                })
        })
        .tint(.bkText)
    }
    
    init(){
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
}

#Preview {
    MainTabView()
}
