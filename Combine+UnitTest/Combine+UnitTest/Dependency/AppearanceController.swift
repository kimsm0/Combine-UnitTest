/**
 @class AppearanceController
 @date 3/18/24
 @writer kimsoomin
 @brief Appearance 데이터 관리 싱글톤 클래스 
 @update history
 - DIContainer에서 관리하는 것으로 구조 변경
 - App에서 DIContainer가 초기화 되는데 이 때, AppearanceControllerable도 같이 초기화 진행
 - 시점 이슈로 인해 App 에서 onAppear 시점에 초기값을 다시 셋팅해주는 것으로 구조 변경
 */
import Foundation
import Combine

protocol AppearanceControllerable {
    var appearance: AppearanceType { get set }
    func changeAppearance(_ type: AppearanceType)    
}

class AppearanceController: AppearanceControllerable, ObservableObjectSettable{
    
    var objectWillChange: ObservableObjectPublisher?
    
    var appearance: AppearanceType = .automatic {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func changeAppearance(_ type: AppearanceType){
        appearance = type
    }
}
