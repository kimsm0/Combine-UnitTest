//
//  HomeModalDestination.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case friendProfile(id: String)
    
    var id: Int {
        hashValue
    }
}
