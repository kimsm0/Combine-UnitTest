/**
 @class AppearanceController
 @date 3/18/24
 @writer kimsoomin
 @brief Appearance 데이터 관리 싱글톤 클래스 
 @update history
 -
 */
import Foundation

class AppearanceController: ObservableObject {
    
    @Published var appearance: AppearanceType
    
    init(_ appearanceValue: Int) {
        self.appearance = AppearanceType(rawValue:  appearanceValue) ?? .automatic
    }
    
    func changeAppearance(_ type: AppearanceType){
        appearance = type
    }
}
