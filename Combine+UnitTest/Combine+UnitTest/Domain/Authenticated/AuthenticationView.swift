//
//  AuthenticationView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var authenticatedViewModel: AuthenticatedViewModel
    @StateObject var navigationRouter: NavigationRouter
    @StateObject var searchDataController: SearchDataController
    
    var body: some View {
        VStack{
            switch authenticatedViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authenticatedViewModel)
            case .authenticated:
                MainTabView()
                    .environment(\.managedObjectContext,  searchDataController.persistantContainer.viewContext)
                    .environmentObject(authenticatedViewModel)
                    .environmentObject(navigationRouter)
            }
        }
        .onAppear{
            authenticatedViewModel.send(action: .checkAuthenticationState)
        }
    }
}

#Preview {
    AuthenticationView(
        authenticatedViewModel: .init(container: DIContainer(services: StubService())), navigationRouter: .init(),
        searchDataController: SearchDataController()
    )
}
