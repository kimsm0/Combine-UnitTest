//
//  LoginButtonStyle.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    
    let textColor: Color
    let borderColor: Color
    
    init(textColor: Color, borderColor: Color) {
        self.textColor = textColor
        self.borderColor = borderColor
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1)
            }
            .padding(.horizontal, 15)
            .opacity(configuration.isPressed ? 0.5 : 1)        
    }
}
