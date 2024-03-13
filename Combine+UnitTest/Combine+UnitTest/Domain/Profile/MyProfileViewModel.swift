//
//  MyProfileViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation

@MainActor
class MyProfileViewModel: ObservableObject {
    private var container: DIContainer
    private var userId: String
    
    @Published var myUserInfo: User?
    @Published var isPresentedDescEditView: Bool = false 
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            myUserInfo = user
        }
    }
    
    func updateDescription(_ newValue: String) async {
        do {
            try await container.services.userService.updateUser(userId: userId, key: "description", value: newValue)
            myUserInfo?.descriptionText = newValue
        }catch {
            
        }
        
    }
}
