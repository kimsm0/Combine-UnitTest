//
//  MyProfileEditView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import SwiftUI

struct MyProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @State var description: String
    
    var completion: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack{
                TextField("상태메시지를 입력해주세요.", text: $description)
                    .multilineTextAlignment(.center)
                
                
            }
            .toolbar{
                Button(action: {
                    completion(description)
                    dismiss()
                }, label: {
                    Text("완료")
                        .foregroundColor(description.isEmpty ? .greyDeep : .bkText)
                }).disabled(description.isEmpty)
            }
        }
    }
}

#Preview {
    MyProfileEditView(description: "", completion: {_ in
        
    })
}
