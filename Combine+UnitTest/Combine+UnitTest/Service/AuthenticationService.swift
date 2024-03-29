/**
 @class AuthenticationService
 @date 3/11/24
 @writer kimsoomin
 @brief 로그인 진행
 @update history
 -
 */
import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

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
        }.eraseToAnyPublisher() //eraseToAnyPublisher은 지금까지의 데이터 스트림이 어떠했던 최종적인 형태의 Publisher를 리턴
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
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        return nil 
    }
    
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>{
        Future{ promise in
            promise(.success(User.init(id: "user_test_id", name: "test", phoneNumber: "010-1111-2222")))
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
