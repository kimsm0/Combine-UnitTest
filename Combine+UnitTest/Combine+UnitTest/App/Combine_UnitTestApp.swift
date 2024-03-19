//
//  Combine_UnitTestApp.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import SwiftUI

@main
struct Combine_UnitTestApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var container: DIContainer = .init(services: Services())
    @AppStorage(AppStorageType.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    
    var body: some Scene {
        WindowGroup { //UIKit의 SceneDelegate
            AuthenticationView(authenticatedViewModel: .init(container: container),
                               navigationRouter: .init(),
                               searchDataController: SearchDataController(),
                               appearanceController: .init(appearance))            
                .environmentObject(container)
        }
    }
}
