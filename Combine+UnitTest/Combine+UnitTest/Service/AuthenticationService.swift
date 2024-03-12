//
//  AuthenticationService.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invalidated
    
}
protocol AuthenticationServiceType {
    func checkAuthenticationState() -> String?
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>
    func logout() -> AnyPublisher<Void, ServiceError>
}

class AuthenticationService:  AuthenticationServiceType{
    
    func checkAuthenticationState() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        return nil 
    }
    
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>{
        Future{ [weak self] promise in
            self?.signInWithGoogle(completion: { result in
                switch result {
                case let .success(user):
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(Void()))
            }catch{
                promise(.failure(ServiceError.error(error)))
            }
        }.eraseToAnyPublisher()
    }
}


extension AuthenticationService {
    private func signInWithGoogle(completion: @escaping( Result<User, Error>) -> Void ){
        //구글 로그인
        //1. clientID로 google confidential 생성
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthenticationError.clientIDError))
            return
        }
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,  let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
                  return
              }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, completion: { [weak self] result, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthenticationError.tokenError))
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            self?.authenticateUserWithFirebase(credential: credential, completion: completion)
            
        })
    }
    
    private func authenticateUserWithFirebase(credential: AuthCredential, completion: @escaping((Result<User, Error>)->Void)){
        Auth.auth().signIn(with: credential, completion: { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let result = result else {
                completion(.failure(AuthenticationError.invalidated))
                return
            }
            
            let firebaseUser = result.user
            let user: User = .init(id: firebaseUser.uid, name: firebaseUser.displayName, phoneNumber: firebaseUser.phoneNumber, profileImageURL: firebaseUser.photoURL?.absoluteString)
            
            completion(.success(user))
        })
    }
}


class StubAuthenticationService:  AuthenticationServiceType{
    func checkAuthenticationState() -> String? {
        return nil
    }    
    
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>{
        Empty().eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
