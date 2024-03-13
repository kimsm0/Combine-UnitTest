//
//  MyProfileMenuType.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation

enum MyProfileMenuType: Hashable, CaseIterable {
    case studio
    case decorate
    case keep
    case story
    
    var description: String {
        switch self {
        case .studio:
            return "스튜디오"
        case .decorate:
            return "꾸미기"
        case .keep:
            return "Keep"
        case .story:
            return "스토리"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .studio:
            return "profile_studio"
        case .decorate:
            return "profile_decorate"
        case .keep:
            return "profile_keep"
        case .story:
            return "profile_story"
        }
    }
}


enum FriendProfileMenuType: Hashable, CaseIterable {
    case chat
    case voiceCall
    case videoCall
    
    var description: String {
        switch self {
        case .chat:
            return "대화"
        case .voiceCall:
            return "음성통화"
        case .videoCall:
            return "영상통화"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .chat:
            return "profile_chat"
        case .voiceCall:
            return "profile_voiceCall"
        case .videoCall:
            return "profile_videoCall"
        }
    }
}
