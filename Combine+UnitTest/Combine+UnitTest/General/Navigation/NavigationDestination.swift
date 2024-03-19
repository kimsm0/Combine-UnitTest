/**
 @class NavigationDestination
 @date 3/13/24
 @writer kimsoomin
 @brief Navigation Stack 으로 연결되는 뷰 타입 정의
 @update history
 -
 */
import Foundation

enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, friendUserId: String)
    case search(userId: String)
}
