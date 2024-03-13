//
//  MyProfileView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import SwiftUI
import PhotosUI

struct MyProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var myProfileViewModel: MyProfileViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0){
                    Spacer()
                    profileView
                        .padding(.bottom, 16)
                    nameView
                        .padding(.bottom, 26)
                    descriptionView
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 58)
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("close")
                    })
                })
            }
            .task { //onAppear가 호출되기 전에 호출됨
                await myProfileViewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        PhotosPicker(selection: $myProfileViewModel.imageSelection,
                     matching: .images,
                     label: {
            Image("profileBigBlue")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        })        
    }
    
    var nameView: some View {
        Text(myProfileViewModel.myUserInfo?.name ?? "이름")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.whiteFix)
    }
    
    var descriptionView: some View {
        Button(action: {
            myProfileViewModel.isPresentedDescEditView.toggle()
        }, label: {
            Text(myProfileViewModel.myUserInfo?.descriptionText ?? "상태메시지를 입력해주세요")
                .font(.system(size: 14))
                .foregroundColor(.white)
        })
        .sheet(isPresented: $myProfileViewModel.isPresentedDescEditView, content: {
            MyProfileEditView(description: myProfileViewModel.myUserInfo?.descriptionText ?? "", completion: { newDescription in
                
                Task{
                    await myProfileViewModel.updateDescription(newDescription)
                }
                
            })
        })
    }
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 27) {
            ForEach(MyProfileMenuType.allCases, id: \.self){ menu in
                Button(action: {
                    
                }, label: {
                    VStack(alignment: .center){
                        Image(menu.iconImageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundColor(.whiteFix)
                    }
                })
            }
        }
    }
}

#Preview {
    MyProfileView(myProfileViewModel: MyProfileViewModel(container: DIContainer(services: StubService()), userId: "test_user_id"))
}
