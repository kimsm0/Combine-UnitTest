/**
 @class UserDBRepository
 @date 3/11/24
 @writer kimsoomin
 @brief UserDB 연동 클래스
 - 새로운 유저 추가, 유저를 DB에서 검색하거나 DB에 있는 유저 리스트를 가지고 오거나 하는 등의 유저 관련  로직을 진행한다.
 @update history
 -
 */
import Foundation
import Combine
//import FirebaseDatabase

protocol UserDBRepositoryType{
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    func getUser(userId: String) async throws -> UserObject
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    func addUserFromContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
    func updateUser(userId: String, key: String, value: Any) async throws
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError>
}

class UserDBRepository: UserDBRepositoryType {
    
    //var db: DatabaseReference = Database.database().reference() //db root
        
    private let reference: DBReferenceType
    init(reference: DBReferenceType) {        
        self.reference = reference
    }
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        Just(object)
            .tryMap{ try JSONEncoder().encode($0)}
            .tryMap{ try JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .mapError{_ in  DBError.invalidate }
            .flatMap{ value in
                self.reference.setValue(key: DBKey.Users, path: object.id, value: value)
            }.eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        
        reference.fetch(key: DBKey.Users, path: userId)
            .flatMap { value in
                if let value {
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: UserObject.self, decoder: JSONDecoder())
                        .mapError {_ in DBError.decodingError }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .emptyValue).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> UserObject {
        guard let value = try await reference.fetch(key: DBKey.Users, path: userId) else {
            throw DBError.emptyValue
        }
        let data = try JSONSerialization.data(withJSONObject: value)
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
        return userObject
    }
    
    
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        reference.fetch(key: DBKey.Users, path: nil)
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as UserObject} }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
                } else {
                    return Fail(error: .invalidate).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func addUserFromContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        Publishers.Zip(users.publisher, users.publisher)
            .compactMap { origin, converted in
                if let converted = try? JSONEncoder().encode(converted) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .compactMap { origin, converted in
                if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .flatMap { [weak self] origin, converted -> AnyPublisher<Void, DBError> in
                guard let `self` = self else { return Empty().eraseToAnyPublisher() }
                return self.reference.setValue(key: DBKey.Users, path: origin.id, value: converted)
            }
            .last()
            .eraseToAnyPublisher()
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        try await reference.setValue(key: DBKey.Users, path: "\(userId)/\(key)", value: value)
    }
    
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError> {
        
        reference.filter(key: DBKey.Users, path: nil, orderedName: "name", queryString: queryString)
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as UserObject} }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
                } else {
                    return Fail(error: .invalidate).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

