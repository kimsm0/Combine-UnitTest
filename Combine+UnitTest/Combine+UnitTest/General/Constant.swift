/**
 @class Constant
 @date 3/11/24
 @writer kimsoomin
 @brief 앱 전역에서 사용되는 키 값 정의
 @update history
 -
 */
import Foundation


typealias DBKey = Constant.DBKey
typealias AppStorageType = Constant.AppStorage

enum Constant {}

extension Constant {
    struct DBKey{
        static let Users = "Users"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
    }
}

extension Constant {
    struct AppStorage {
        static let Appearance = "AppStorage_Appearance"
    }
}

