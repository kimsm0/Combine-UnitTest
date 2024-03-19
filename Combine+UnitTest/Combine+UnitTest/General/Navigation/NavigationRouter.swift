/**
 @class NavigationRouter
 @date 3/13/24
 @writer kimsoomin
 @brief NavigationStack을 관리할 싱글톤 클래스
 @update history
 -
 */
import Foundation

class NavigationRouter: ObservableObject {
    @Published var destination: [NavigationDestination] = [] //뷰타입
    
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
