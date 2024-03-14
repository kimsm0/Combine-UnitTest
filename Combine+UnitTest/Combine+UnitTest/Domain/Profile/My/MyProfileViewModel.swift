/**
 @class MyProfileViewModel
 @date 3/13/24
 @writer kimsoomin
 @brief
 @MainActor : Swift의 Concurrency를 사용할 때 해당 클래스의 모든 속성과 메서드가 메인 큐에서 자동으로 설정 및 호출/접근 된다는것을 의미.
 DisapatchQueue.main.async과 같은 수동 호출 불필요
 
 @update history
 -
 */
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
            try await container.services.userService.updateUser(userId: userId, key: "descriptionText", value: newValue)
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
