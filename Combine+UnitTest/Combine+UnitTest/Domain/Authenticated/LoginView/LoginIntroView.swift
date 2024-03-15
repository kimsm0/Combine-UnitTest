//
//  LoginIntroView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI

struct LoginIntroView: View {
    @State private var isPresentedLoginView: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                Spacer()
                Text("환영합니다.")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.bkText)
                
                Text("무료 메시지와 영상통화, 음성통화를 부담없이 즐겨보세요..")
                    .font(.system(size: 12))
                    .foregroundColor(.greyDeep)
                
                Spacer()
                
                Button(action: {
                    isPresentedLoginView.toggle()
                    
                }, label: {
                    Text("로그인")
                }).buttonStyle(LoginButtonStyle(textColor: .app, borderColor: .app))
            }
            .navigationDestination(isPresented: $isPresentedLoginView, destination: {
                LoginView()
            })            
        }
    }
}

#Preview {
    LoginIntroView()
}
