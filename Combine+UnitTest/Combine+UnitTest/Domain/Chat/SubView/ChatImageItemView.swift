//
//  ChatImageItemView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import SwiftUI

struct ChatImageItemView: View {
    var urlString: String
    var direction: ChatItemDirection
    
    var body: some View {
    
        HStack{
            if direction == .right {
                Spacer()
            }
            URLImageView(urlString: urlString, placeHolderImageName: nil)
                .frame(width: 146, height: 146)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if direction == .left {
                Spacer()
            }
        }
        .padding(.horizontal, 35)
    }
}

#Preview {
    ChatImageItemView(urlString: "", direction: .left)
}
