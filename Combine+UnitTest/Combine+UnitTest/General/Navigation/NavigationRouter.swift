//
//  NavigationRouter.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation

class NavigationRouter: ObservableObject {
    @Published var destination: [NavigationDestination] = []
    
    func push(to view: NavigationDestination){
        destination.append(view)
    }
    
    func pop(){
        _ = destination.popLast()
    }
    
    func popToRootView() {
        destination = []
    }
}
