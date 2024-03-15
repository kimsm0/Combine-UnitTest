//
//  ChatItemView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import SwiftUI

struct ChatItemView: View {
    let message: String
    let direction: ChatItemDirection
    let date: Date
    
    var body: some View {
        HStack(alignment: .bottom) {
            if direction == .right {
                Spacer()
                dateView
            }
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.bk2Fix)
                .padding(.vertical, 9)
                .padding(.horizontal, 20)
                .background(direction.bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .overlay(alignment: direction.overlayAlightment){
                    direction.overlayImage
                }
            
            if direction == .left {
                dateView
                Spacer()
            }
        }
        .padding(.horizontal, 35)
    }
    
    var dateView: some View {
        Text(date.convertToString(formatType: nil, formatString: "a h:mm"))
            .font(.system(size: 10))
            .foregroundColor(.greyDeep)
        
    }
}

#Preview {
    ChatItemView(message: "안녕하세요", direction: .right, date: Date())
}


enum ChatItemDirection {
    case left //친구
    case right //나
    
    var bgColor: Color {
        switch self {
        case .left:
            return .whiteFix
        case .right:
            return .chatColorMe
        }
    }
    
    var overlayAlightment: Alignment {
        switch self {
        case .left:
            return .topLeading
        case .right:
            return .topTrailing
        }
    }
    
    var overlayImage: Image {
        switch self {
        case .left:
            return Image("chatInput")
        case .right:
            return Image("chatOutput")
        }
    }
}
