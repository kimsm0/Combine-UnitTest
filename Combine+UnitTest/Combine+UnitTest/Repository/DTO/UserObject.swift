/**
 @class UserObject
 @date 3/11/24
 @writer kimsoomin
 @brief 
 @update history
 -
 */
import Foundation

struct UserObject: Codable {
    var id: String
    var name: String?
    var phoneNumber: String?
    var profileImageURL: String?
    var descriptionText: String?
}

extension UserObject {
    func toModel() -> User {
        .init(id: id, name: name, phoneNumber: phoneNumber, profileImageURL: profileImageURL, descriptionText: descriptionText)
    }
}



