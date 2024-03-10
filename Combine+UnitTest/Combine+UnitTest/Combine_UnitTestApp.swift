//
//  Combine_UnitTestApp.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/10/24.
//

import SwiftUI

@main
struct Combine_UnitTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
