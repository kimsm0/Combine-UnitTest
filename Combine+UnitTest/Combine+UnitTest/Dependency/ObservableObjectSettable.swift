/**
 @protocol ObservableObjectSettable
 @date 3/20/24
 @writer kimsoomin
 @brief
 - ObservableObject 프로토콜을 체택하여 구현한 NavigationRouter, AppearanceController를 DIContainer에서 가져다 사용하는 것으로 구조를 변경하면서 기존에 사용하던 @Publish 역할을 연결시켜줄 로직이 추가되었다.
 - NavigationRouter, AppearanceController 공통으로 같은 로직이 필요하여 ObservableObjectSettable 프토토콜로 분리.
 - 공통 로직을 프로토콜에서 구현하여 코드 정리
 @update history
 -
 */
import Foundation
import Combine

protocol ObservableObjectSettable: AnyObject{
    var objectWillChange: ObservableObjectPublisher? { get set }
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher)
}

extension ObservableObjectSettable{
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher) {
        self.objectWillChange = objectWillChange
    }
}
