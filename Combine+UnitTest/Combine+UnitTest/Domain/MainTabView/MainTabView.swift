/**
 @class MainTabView
 @date 3/11/24
 @writer kimsoomin
 @brief AuthenticatedViewModel ( 뷰모델 1개 뷰 n개 ) 바인딩
 
 @update history
 -
 */
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticatedViewModel
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            
                ForEach(MainTabType.allCases, id:\.self, content: { tab in
                    Group{
                        switch tab {
                        case .home:
                            HomeView(homeViewModel: .init(container: container, navigationRouter: navigationRouter, userId: authViewModel.userId ?? ""))
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
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(AuthenticatedViewModel(container: DIContainer(services: StubService())))
        .environmentObject(NavigationRouter())
}
