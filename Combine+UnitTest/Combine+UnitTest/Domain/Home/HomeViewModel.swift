//
//  HomeViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    enum Action{
        case getUser
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    
    private var userId: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    init(container: DIContainer, userId: String){
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action){
        switch action{
        case .getUser:
            container.services.userService.getUser(userId: userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                }.store(in: &subscriptions)

            return
        }
    }
}
