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
    
    enum Action{
        case googleLogin
        case appleLogin
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    private var container: DIContainer
    var userId: String?
    private var subscriptions = Set<AnyCancellable>()
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .googleLogin:
        
            container.services.authService.signInWithGoogle()
                .sink { completion in
                    
                } receiveValue: {[weak self] user in
                    self?.userId = user.id
                }.store(in: &subscriptions)

            break
        case .appleLogin:
            break
        }        
    }
}
