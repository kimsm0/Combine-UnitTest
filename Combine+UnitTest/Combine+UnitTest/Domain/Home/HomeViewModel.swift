//
//  HomeViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation


class HomeViewModel: ObservableObject{
    @Published var myUser: User?
    @Published var users: [User] = [.stub1, .stub2]
    
    init(myUser: User?) {
        self.myUser = myUser
    }
}
