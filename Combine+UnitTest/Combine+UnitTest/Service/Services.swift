//
//  Services.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
    var contactService: ContactServiceType { get set }
    
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    
    init(authService: AuthenticationServiceType) {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
    }
}


// MARK: Preview용 service
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = StubContactService()
}
