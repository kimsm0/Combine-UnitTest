//
//  MainTabType.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case home
    case chat
    case phone
    
    var titlle: String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "대화"
        case .phone:
            return "통화"
        }
    }
    
    func imageName(selected: Bool) -> String{
        return selected ? "tab_\(rawValue)_on" : "tab_\(rawValue)_off"
    }
}
