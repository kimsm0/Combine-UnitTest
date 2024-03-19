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
import FirebaseDatabase

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
    
    var db: DatabaseReference = Database.database().reference() //db root
        
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap{ try? JSONEncoder().encode($0)}
            .compactMap{ try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap{ value in
                Future<Void, Error> {[weak self] promise in
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        }else{
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError{ DBError.error($0) }
            .eraseToAnyPublisher()
        
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> {[weak self] promise in
            self?.db.child(DBKey.Users).child(userId).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                }else if snapshot?.value is NSNull {
                    promise(.success(nil))
                }else{
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap{ value in
            if let value {
                return Just(value)
                    .tryMap{ try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: UserObject.self, decoder: JSONDecoder())
                    .mapError{ DBError.error($0)}
                    .eraseToAnyPublisher()
            }else {
                return Fail(error: .emptyValue).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> UserObject {
        guard let value  = try await self.db.child(DBKey.Users).child(userId).getData().value else {
            throw DBError.emptyValue
        }
        let data = try JSONSerialization.data(withJSONObject: value)
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
        return userObject
    }
    
    
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        Future<Any?, DBError> {[weak self] promise in
            self?.db.child(DBKey.Users).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                }else if snapshot?.value is NSNull {
                    promise(.success(nil))
                }else{
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap{ value in
            if let dic = value as? [String: [String: Any]] {
                return Just(dic)
                    .tryMap{ try JSONSerialization.data(withJSONObject: $0)}
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                    .map{ $0.values.map {$0 as UserObject} }
                    .mapError{ DBError.error($0)}
                    .eraseToAnyPublisher()

            }else if value == nil  {
                return Just([]).setFailureType(to: DBError.self)
                    .eraseToAnyPublisher()
            }else{
                //타입도 맞지 않고 데이터도 없는 경우 = 실패 리턴
                return Fail(error: .invalidate).eraseToAnyPublisher()
            }
            
        }.eraseToAnyPublisher()
    }
    
    func addUserFromContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        Publishers.Zip(users.publisher, users.publisher)
            .compactMap{ origin, converted in                
                if let converted = try? JSONEncoder().encode(converted){
                    return (origin, converted)
                }else {
                   return  nil
                }
            }.compactMap{ origin, converted in
                if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
                    return (origin, converted)
                }else{
                    return nil
                }
            }.flatMap{ origin, converted in
                Future <Void, Error> {[weak self] promise in
                    self?.db.child(DBKey.Users).child(origin.id).setValue(converted) { error, _ in
                        if let error {
                            promise(.failure(error))
                        }else{
                            promise(.success(()))
                        }
                    }
                }
            }.last()
            .mapError{
                .error($0)
            }.eraseToAnyPublisher()
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        try await self.db.child(DBKey.Users).child(userId).child(key).setValue(value)
    }
    
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError> {
        Future{ [weak self] promise in
            self?.db.child(DBKey.Users)
                .queryOrdered(byChild: "name")
                .queryStarting(atValue: queryString)
                .queryEnding(atValue: queryString + "\u{f8ff}") //unicode last
                .observeSingleEvent(of: .value, with: { snapshot in
                    promise(.success(snapshot.value))
                })
        }.flatMap{ value in
            if let dic = value as? [String : [String: Any]] {
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                    .map{ $0.values.map { $0 as UserObject }}
                    .mapError{ DBError.error($0) }
                    .eraseToAnyPublisher()
            }else if value == nil {
                return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
            }else {
                return Fail(error: DBError.invalidate).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
}

