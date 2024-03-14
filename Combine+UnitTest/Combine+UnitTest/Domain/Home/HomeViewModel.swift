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
        case loadUser
        case presentMyProfileView
        case presentFriendProfileView(id: String)
        case requestContacts
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    private var container: DIContainer
    private var navigationRouter: NavigationRouter
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, navigationRouter: NavigationRouter, userId: String){
        self.container = container
        self.navigationRouter = navigationRouter
        self.userId = userId
    }
    
    func send(action: Action){
        switch action{
        case .getUser:
            phase = .loading
            container.services.userService.getUser(userId: userId)
                .sink {[weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                    self?.phase = .success
                }.store(in: &subscriptions)
            return
        case .loadUser:
            phase = .loading
            container.services.userService.loadUsers(myId: userId)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: {[weak self] users in
                    self?.users = users
                    self?.phase = .success
                }.store(in: &subscriptions)
        case .presentMyProfileView:
            modalDestination = .myProfile
        case .presentFriendProfileView(let id ):
            modalDestination = .friendProfile(id: id)
        case .requestContacts:
            container.services.contactService.fetchContacts()
                .flatMap{ users in
                    self.container.services.userService.addUserFromContact(users: users)
                }.flatMap{ _ in
                    self.container.services.userService.loadUsers(myId: self.userId)
                }.sink {[weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: {[weak self] users in
                    self?.users = users
                    self?.phase = .success
                }.store(in: &subscriptions)
        }
    }
}
