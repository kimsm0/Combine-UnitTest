/**
 @class NavigationRoutingView
 @date 3/15/24
 @writer kimsoomin
 @brief Navigation Stack을 공통으로 관리하기 위한 뷰
 @update history
 -
 */
import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case let .chat(chatRoomId, myUserId, friendUserId):
            ChatView(chatViewModel: .init(chatRoomId: chatRoomId, myUserId: myUserId, friendUserId: friendUserId, container: container))
        case let .search(userId):
            SearchView(searchViewModel: .init(container: container, userId: userId))
        }
    }
}

#Preview {
    NavigationRoutingView(destination: .search(userId: "testUserId"))
    
}
