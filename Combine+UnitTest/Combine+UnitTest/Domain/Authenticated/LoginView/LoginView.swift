/**
 @class LoginView
 @date 3/11/24
 @writer kimsoomin
 @brief AuthenticatedViewModel ( 뷰모델 1개 뷰 n개 ) 바인딩
 
 @update history
 -
 */
import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss //dismiss Action
    @EnvironmentObject var authViewModel: AuthenticatedViewModel
    
    var body: some View {
    
        VStack(alignment: .leading) {
            Group{
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.top, 80)
                
                Spacer()
                    .frame(height: 8)
                
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundColor(.greyDeep)
            }.padding(.horizontal, 30)
                            
            Spacer()
            
            Button(action: {
                // TODO: 
            }, label: {
                Text("Apple 로그인")
            }).buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
            
            Spacer()
                .frame(height: 16)
            
            Button(action: {
                authViewModel.send(action: .googleLogin)
            }, label: {
                Text("Google 로그인")
            }).buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
                .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarLeading, content: {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("back")
                })
            })
        }
        .overlay(alignment: .center, content: { //addSubView
            if authViewModel.isLoading{
                ProgressView()
            }
        })
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticatedViewModel(container: .init(services: StubService())))
}
