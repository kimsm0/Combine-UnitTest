/**
 @class NavigationRouter
 @date 3/13/24
 @writer kimsoomin
 @brief NavigationStack을 관리할 싱글톤 클래스
 @update history
 - DIContainer에서 관리할 수 있도록 리팩토링
 - 기존에 NavigationRouter에서 체택한 ObservableObject를 DIContaiiner에서도 체택하고 있어 여기서는 제거.
 - DIContainer의 objectWillChange를 받아서 수동으로 set하고 뷰로 데이터 업데이트를 방출할 수 있도록 구조 변경
 */
import Foundation
import Combine

protocol NavigationRoutable {
    var destination: [NavigationDestination] { get set }
    func push(to view: NavigationDestination)
    func pop()
    func popToRootView()
    
}

class NavigationRouter: NavigationRoutable, ObservableObjectSettable{
    var objectWillChange: ObservableObjectPublisher?
    
    var destination: [NavigationDestination] = [] { //뷰타입
        didSet{
            objectWillChange?.send()
        }
    }
    func push(to view: NavigationDestination){
        destination.append(view)
    }
    
    func pop(){
        _ = destination.popLast()
    }
    
    func popToRootView() {
        destination = []
    }        
}
