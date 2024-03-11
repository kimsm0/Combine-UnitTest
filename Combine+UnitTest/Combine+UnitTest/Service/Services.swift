//
//  Services.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    
    init(authService: AuthenticationServiceType) {
        self.authService = authService
    }
    
}


// MARK: Preview용 service
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
}
