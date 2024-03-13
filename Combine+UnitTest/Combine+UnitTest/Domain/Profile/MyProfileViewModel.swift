//
//  MyProfileViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class MyProfileViewModel: ObservableObject {
    private var container: DIContainer
    private var userId: String
    
    @Published var myUserInfo: User?
    @Published var isPresentedDescEditView: Bool = false 
    @Published var imageSelection: PhotosPickerItem? {
        didSet{
            Task {
                await updateProfileImage(pickerItem: imageSelection)
            }
        }
    }
    
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
            print(error.localizedDescription)
        }
    }
    
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return }
        
        do {
            let data =  try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            let url = try await container.services.uploadService.uploadImage(source: .profile(userId: userId), data: data)
            
            try await container.services.userService.updateUser(userId: userId, key: "profileImageURL", value: url.absoluteString)
            
            myUserInfo?.profileImageURL = url.absoluteString
        } catch {
            print(error.localizedDescription)
        }
    }
}
