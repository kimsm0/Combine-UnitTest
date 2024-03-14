/**
 @class FriendProfileViewModel
 @date 3/13/24
 @writer kimsoomin
 @brief 
 @update history
 -
 */
import Foundation

@MainActor
class FriendProfileViewModel: ObservableObject {
    
    enum Action {
        case loadUser
        case chat
    }
        
    @Published var user: User?
    private var userId: String
    private var container: DIContainer
    
    init(userId: String, container: DIContainer) {
        self.userId = userId
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .loadUser:
            Task{
                await getUser()
            }
        case .chat:
            goToChat()
        }
    }
}


extension FriendProfileViewModel {
    func getUser() async {
        do {
            let user = try await container.services.userService.getUser(userId: userId)
            self.user = user
        }catch {
            
        }
    }
    
    private func goToChat(){
        
    }
}
