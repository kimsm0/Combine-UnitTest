//
//  AuthenticationView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import SwiftUI

//최상단 뷰

struct AuthenticationView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var authenticatedViewModel: AuthenticatedViewModel
    
    var body: some View {
        VStack{
            switch authenticatedViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authenticatedViewModel)
            case .authenticated:
                MainTabView()
                    .environment(\.managedObjectContext,  container.searchDataController.persistantContainer.viewContext)
                    .environmentObject(authenticatedViewModel)
            }
        }
        .onAppear{
            authenticatedViewModel.send(action: .checkAuthenticationState)
        }
        .preferredColorScheme(container.appearanceController.appearance.colorScheme)
    }
}

#Preview {
    AuthenticationView(
        authenticatedViewModel: .init(container: DIContainer(services: StubService())))
}
