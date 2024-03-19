/**
 @class SearchButtonView
 @date 3/15/24
 @writer kimsoomin
 @brief 검색 영역 뷰 클래스
 tab하면 검색화면으로 이동하는 역할로, 다른 액션은 없는 단순 뷰 
 @update history
 -
 */

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
