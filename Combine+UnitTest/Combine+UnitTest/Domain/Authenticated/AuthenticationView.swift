//
//  AuthenticationView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var authenticatedViewModel: AuthenticatedViewModel
        
    var body: some View {
        switch authenticatedViewModel.authenticationState {
        case .unauthenticated:
            LoginIntroView()
                .environmentObject(authenticatedViewModel)
        case .authenticated:
            MainTabView()            
        }
    }
}

#Preview {
    AuthenticationView(
        authenticatedViewModel: .init(container: DIContainer(services: StubService()))
    )
}
