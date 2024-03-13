//
//  UserService.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation
import Combine

protocol UserServiceType{
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String)-> AnyPublisher<User, ServiceError>
    func getUser(userId: String) async throws -> User
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError>
    func addUserFromContact(users: [User]) -> AnyPublisher<Void, ServiceError>
    func updateUser(userId: String, key: String, value: Any) async throws
}

class UserService: UserServiceType{
    
    private var dbRepository: UserDBRepositoryType
    
    init(dbRepository: UserDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        dbRepository.addUser(user.toObject())
            .map{ user }
            .mapError{ .error($0) }
            .eraseToAnyPublisher()
    }
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toModel() }
            .mapError{ .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        let userObject = try await dbRepository.getUser(userId: userId)
        return userObject.toModel()
    }
    
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()
            .map{ $0.map{ $0.toModel() }.filter({$0.id != myId })}
            .mapError{.error($0)}
            .eraseToAnyPublisher()
    }
    
    func addUserFromContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        dbRepository.addUserFromContact(users: users.map{ $0.toObject()})
            .mapError{.error($0)}
            .eraseToAnyPublisher()
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        try await dbRepository.updateUser(userId: userId, key: key, value: value)
    }
}


class StubUserService: UserServiceType{
        
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        return .stub1
    }
    
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func addUserFromContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        
    }
}
