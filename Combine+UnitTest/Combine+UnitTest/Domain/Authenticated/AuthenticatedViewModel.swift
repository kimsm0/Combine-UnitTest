//
//  AuthenticatedViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import Foundation
import Combine

enum AuthenticationState {
    case unauthenticated
    case authenticated
}


class AuthenticatedViewModel: ObservableObject{
    
    enum Action {
        case checkAuthenticationState
        case googleLogin
        case appleLogin
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading = false
    
    private var container: DIContainer
    var userId: String?
    private var subscriptions = Set<AnyCancellable>()
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let uid = container.services.authService.checkAuthenticationState() {
                self.userId = uid
                self.authenticationState = .authenticated
            }
        case .googleLogin:
            isLoading = true
            container.services.authService.signInWithGoogle()
                .sink { completion in
                    if case .failure = completion{
                        self.isLoading = false 
                    }
                } receiveValue: {[weak self] user in
                    self?.userId = user.id
                    self?.isLoading = false
                    self?.authenticationState = .authenticated
                }.store(in: &subscriptions)

            break
        case .appleLogin:
            break
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscriptions)
            break
        }        
    }
}
