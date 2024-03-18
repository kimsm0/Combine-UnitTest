//
//  SearchViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    enum Action {
        case searchUser(String)
        case clearSearchResult
        case clearSearchText
    }
    private let container: DIContainer
    private let userId: String
    
    @Published var searchText: String = ""
    @Published var searchUsers: [User] = []
    @Published var shouldBecomeFirstResponder: Bool = false 
    
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
        bind()
    }
    
    func bind(){
        $searchText
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .removeDuplicates() //동일검색어 검색 x
            .sink {[weak self] text in
                if !text.isEmpty {
                    self?.send(.searchUser(text))
                }else{
                    self?.send(.clearSearchResult)
                }
            }.store(in: &subscription)
    }
    
    func send(_ action: Action) {
        switch action{
        case let .searchUser(query):
            container.services.userService.filterUsers(with: query, userId: userId)
                .sink { completion in
                    
                } receiveValue: {[weak self] users in
                    self?.searchUsers = users
                }.store(in: &subscription)
        case .clearSearchResult:
            searchUsers = []
        case .clearSearchText:
            searchUsers = []
            shouldBecomeFirstResponder = false
            searchText = ""
        }
    }
}

