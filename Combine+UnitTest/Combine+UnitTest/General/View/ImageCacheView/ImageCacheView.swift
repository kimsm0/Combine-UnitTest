/**
 @class ImageCacheView
 @date 3/13/24
 @writer kimsoomin
 @brief url 이미지를 보여주는 이미지 뷰 클래스
 메모리 캐시 -> 디스크 캐시 -> url 순서로 확인, 진행하여 이미지를 셋팅한다. 
 @update history
 -
 */

import SwiftUI

struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    
    let urlString: String?
    let placeHolderImageName: String
    
    init(urlString: String?, placeHolderImageName: String?) {
        self.urlString = urlString
        self.placeHolderImageName = placeHolderImageName ?? "profileBigBlue"
    }
    
    var body: some View {
        if let urlString, !urlString.isEmpty {
            ImageCacheView(imageCacheViewModel: .init(urlString: urlString, container: container), placeHolderImageName: placeHolderImageName)
                .id(urlString)
        }else{
            Image(placeHolderImageName)
                .resizable()
        }
    }
}

fileprivate struct ImageCacheView: View {
    @StateObject var imageCacheViewModel: ImageCacheViewModel
    
    let placeHolderImageName: String
            
    var placeHolderImage: UIImage {
        UIImage(named: placeHolderImageName) ?? UIImage()
    }       
    
    var body: some View {
        Image(uiImage: imageCacheViewModel.loadedImage ?? placeHolderImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onAppear{
                if !imageCacheViewModel.loadingOrSuccess {
                    imageCacheViewModel.start()
                }
            }
    }
}

#Preview {
    URLImageView(urlString: nil, placeHolderImageName: "profileBigBlue")
}
