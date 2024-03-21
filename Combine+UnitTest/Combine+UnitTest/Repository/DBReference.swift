/**
 @class DBReference
 @date 3/20/24
 @writer kimsoomin
 @brief
 - 테스트 진행시 DBReferenceType 체택하고 있는 어떤 객체도 DBRepository 주입이 되어 firebase와의 연결을 테스트해볼 수 있도록 하기 위해 분리한 클래스
 @update history
 - Test Double 추가
 */
import Foundation
import Combine
import FirebaseDatabase

protocol DBReferenceType {
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError>
    func setValue(key: String, path: String?, value: Any) async throws
    func setValues(_ values: [String: Any]) -> AnyPublisher<Void, DBError>
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func fetch(key: String, path: String?) async throws -> Any?
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError>
    func childByAutoId(key: String, path: String?) -> String?
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func removeObservedHandlers()
}

class DBReference: DBReferenceType {
    
    var db: DatabaseReference = Database.database().reference()
    
    var observedHandlers: [UInt] = []
    
    private func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }
    
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Void, DBError> { [weak self] promise in
            self?.db.child(path).setValue(value) { error, _ in
                if let error {
                    promise(.failure(.error(error)))
                } else {
                    promise (.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func setValue(key: String, path: String?, value: Any) async throws {
        try await db.child(getPath(key: key, path: path)).setValue(value)
    }
    
    func setValues(_ values: [String: Any]) -> AnyPublisher<Void, DBError> {
        Future<Void, DBError> { [weak self] promise in
            self?.db.updateChildValues(values) { error, _ in
                if let error {
                    promise(.failure(.error(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Any?, DBError> { [weak self] promise in
            self?.db.child(path).getData { error, snapshot in
                if let error {
                    promise(.failure(.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) async throws -> Any? {
        try await db.child(getPath(key: key, path: path)).getData().value
    }
    
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Any?, DBError> { [weak self] promise in
            self?.db.child(path)
                .queryOrdered(byChild: orderedName)
                .queryStarting(atValue: queryString)
                .queryEnding(atValue: queryString + "\u{f8ff}")
                .observeSingleEvent(of: .value) { snapshot in
                    promise(.success(snapshot.value))
                }
        }.eraseToAnyPublisher()
    }
    
    func childByAutoId(key: String, path: String?) -> String? {
        db.child(getPath(key: key, path: path)).childByAutoId().key
    }
    
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let subject = PassthroughSubject<Any?, DBError>()
       
        let handler = db.child(getPath(key: key, path: path)).observe(.childAdded) { snapshot in
            subject.send(snapshot.value)
        }
        
        observedHandlers.append(handler)
        
        return subject.eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        observedHandlers.forEach {
            db.removeObserver(withHandle: $0)
        }
    }
}

struct StubUserDBReference: DBReferenceType {
    
    let value: Any? //test용 데이터
    
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        return Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        Just(value).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func setValue(key: String, path: String?, value: Any) async throws {
    }
    
    func setValues(_ values: [String : Any]) -> AnyPublisher<Void, Combine_UnitTest.DBError> {
        Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    

    func fetch(key: String, path: String?) async throws -> Any? {
        return value
    }
    
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, Combine_UnitTest.DBError> {
        Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func childByAutoId(key: String, path: String?) -> String? {
        return nil
    }
    
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, Combine_UnitTest.DBError> {
        Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }

    func removeObservedHandlers() {
    }
}
  
