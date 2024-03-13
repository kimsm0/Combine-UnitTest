/**
 @class Services
 @date 3/10/24
 @writer kimsoomin
 @brief Service Layer
  ViewModel -> 호출
 @update history
 -
 */
import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
    var contactService: ContactServiceType { get set }
    var photoPickerService: PhotoPickerServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    var photoPickerService: PhotoPickerServiceType
    
    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
        self.photoPickerService = PhotoPickerService()
    }
}


// MARK: Preview용 service
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = StubContactService()
    var photoPickerService: PhotoPickerServiceType = StupPhotoPickerService()
}
