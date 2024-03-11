//
//  LoginView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
    
        VStack(alignment: .leading) {
            
            Group{
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.top, 80)
                
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundColor(.greyDeep)
            }.padding(.horizontal, 30)
                            
            Spacer()
            
            Button(action: {
                // TODO: apple login
            }, label: {
                Text("Apple 로그인")
            }).buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
            
            Button(action: {
                // TODO: apple login
            }, label: {
                Text("Google 로그인")
            }).buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
        }.navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("back")
                    })
                })
            }
    }
}

#Preview {
    LoginView()
}
