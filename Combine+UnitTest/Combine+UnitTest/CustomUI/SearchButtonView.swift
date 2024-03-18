//
//  SearchButtonView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/15/24.
//

import SwiftUI

struct SearchButtonView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.greyCool)
                .frame(height: 36)
                .cornerRadius(5)
            
            HStack{
                Text("검색")
                    .font(.system(size: 12))
                    .foregroundColor(.greyDeep)
                
                Spacer()
                
            }.padding(.leading, 22)
            
        }.padding(.horizontal, 30)        
    }
}

#Preview {
    SearchButtonView()
}
