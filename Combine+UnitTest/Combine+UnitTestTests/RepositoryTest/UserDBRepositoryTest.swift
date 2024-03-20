//
//  UserDBRepositoryTest.swift
//  Combine+UnitTestTests
//
//  Created by kimsoomin_mac2022 on 3/20/24.
//

import XCTest
import Combine
@testable import Combine_UnitTest

final class UserDBRepositoryTest: XCTestCase {

    private var subscrition = Set<AnyCancellable>()
    
    //test실행되기 전에 호출되는 부분으로 전처리 작업 진행
    override func setUpWithError() throws {
        subscrition = Set<AnyCancellable>()
    }

    //종료되면 실행되는 부분, setup 설정한 값들을 해제
    override func tearDownWithError() throws {
    }

    
    func test_getUser_success(){
        let stubData = [
            "id":"test_userId",
            "name":"testUser1"]
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: stubData))
        userDBRepository.getUser(userId: "testUser1")
            .sink { completion in
            
                if case let .failure(error) = completion {
                    XCTFail("Unexpected fail: \(error)")
                }
            } receiveValue: { user in
                XCTAssertNotNil(user)
                XCTAssertEqual(user.id, "test_userId")
                XCTAssertEqual(user.name, "testUser1")
            }.store(in: &subscrition)
    }
    func test_getUser_empty() {
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: nil))
        
        userDBRepository.getUser(userId: "user1_id")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error.localizedDescription, DBError.emptyValue.localizedDescription)
                }
            } receiveValue: { userObject in
                XCTFail("Unexpected success: \(userObject)")
            }.store(in: &subscrition)
    }
    
    func test_getUser_fail() {
        let stubData = [
            "id_modified": "test_userId",
            "name_modified": "testUser1"
        ]
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: stubData))
        
        userDBRepository.getUser(userId: "user1_id")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error)
                }
            } receiveValue: { userObject in
                XCTFail("Unexpected success: \(userObject)")
            }.store(in: &subscrition)
    }

}
struct StubUserDBReference: DBReferenceType {
    
    let value: Any?
    
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
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
	    
