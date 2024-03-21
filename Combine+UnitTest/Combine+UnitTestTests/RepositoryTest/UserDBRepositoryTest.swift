/**
 @class UserDBRepositoryTest
 @date 3/20/24
 @writer kimsoomin
 @brief  
 - 테스트를 진행하기 위한 StubUserDBReference를 사용하여 UserDBRepository를 초기화 한다.
 - 전역 변수로 Stub 데이터가 들어가 있는 DBReference를 사용한다.
 - 특정 케이스의 stub data를 사용하여 검증해야 하는 경우에는 테스트 메소드 안에, UserDBRepository 따로 생성하여 검증을 진행한다.
 
 @update history
 -
 */
import XCTest
import Combine
@testable import Combine_UnitTest

final class UserDBRepositoryTest: XCTestCase {

    private var subscrition = Set<AnyCancellable>()
    
    private let test_id = TestDouble.getString(1, key: "id")
    private let test_name = TestDouble.getString(1, key: "name")
    
    private var userDBRepository = UserDBRepository(reference: StubUserDBReference(value: nil))
    
    //test실행되기 전에 호출되는 부분으로 전처리 작업 진행
    override func setUpWithError() throws {
        subscrition = Set<AnyCancellable>()
        userDBRepository = UserDBRepository(reference: StubUserDBReference(value: TestDouble.getUserDictionary(1)))
    }

    //종료되면 실행되는 부분, setup 설정한 값들을 해제
    override func tearDownWithError() throws {
    }
    
    /**
     @brief UserObject의 Encoding/JsonObject 변환 검증
     - 전역변수로 사용하는 userDBRepository에는 전역변수의 stub data가 들어가 있다.
     - StubDBReference에서는 실제로 db에 데이터를 넣지는 않으므로 addUser에 넘기는 Object는 의미가 있지는 않다.
     - 다만, addUser의 DB 에 데이터를 넣기 전에 수행하는 전처리 과정을 검증해볼 수 있다.
     - 해당 과정에서 에러가 던져지면 테스트를 통과할 수 없다.
     */
    func test_addUser_success(){
        userDBRepository.addUser(TestDouble.getUserObject(1))
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("❌ completion -> \(error)")
                }
            } receiveValue: { _ in
            }.store(in: &subscrition)
    }
        
    /**
     @brief UserDB에서 UserId로 데이터를 찾은 경우, 로직을 검증
     - StubDBReference에 들어간 동일한 Stub Data가 retrurn되었을 때, 디코딩 과정을 검증한다.
     - 리턴되는 데이터가 nil 아니고, stub 데이터 값과 동일해야 테스트 통과.
     */
    func test_getUser_success(){
        userDBRepository.getUser(userId: test_id)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("❌ completion -> \(error)")
                }
            } receiveValue: { user in
                XCTAssertNotNil(user)
                XCTAssertEqual(user.id, self.test_id)
                XCTAssertEqual(user.name, self.test_name)
            }.store(in: &subscrition)
    }
        
    /**
     @brief UserDB에서 UserId로 검색시 데이터가 없는 로직 검증한다.
     - 전역변수로 선언된 repo를 사용하지 않고, 값이 없는 repo를 새로 생성하여 검증한다.
     - DBError.emptyValue 에러를 받아야 테스트 통과
     */
    func test_getUser_empty() {
        
        var emptyUserDBRepository = UserDBRepository(reference: StubUserDBReference(value: nil))
        
        emptyUserDBRepository.getUser(userId: test_id)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error.localizedDescription, DBError.emptyValue.localizedDescription)
                }
            } receiveValue: { userObject in
                XCTFail("❌ receiveValue -> \(userObject)")
            }.store(in: &subscrition)
    }
        
    /**
     @brief UserDB에서 UserId로 검색 후 리던받은 Data를 decoding하는 로직 검증한다.
     - db 구조와 다른 포맷으로 data를 전달했을 때, 정상적으로 에러가 발생되는지를 확인한다.
     - DBError.decodingError가 발생되어야 테스트 통과.
     */
    func test_getUser_fail() {
        //key값이 UserObject와 다른 케이스 -> 디코딩 에러 확인
        let test_id = TestDouble.getString(1, key: "id")
        let test_name = TestDouble.getString(1, key: "name")
        
        let fakeUserObject = [
            "id_modified": test_id,
            "name_modified": test_name
        ]
        
        let fakeUserDBRepository = UserDBRepository(reference: StubUserDBReference(value: fakeUserObject))
        
        fakeUserDBRepository.getUser(userId: test_id)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertEqual(error.localizedDescription, DBError.decodingError.localizedDescription)
                }
            } receiveValue: { userObject in
                XCTAssertNil(userObject)
            }.store(in: &subscrition)
    }
    
    /**
     @brief DB에서 User 리스트 데이터를 읽어오는 로직을 검증한다.
     - 리턴되는 데이터가 비어있지 않아야 테스트 통과.
     */
    func test_loadUsers_success(){
        let users = [
            test_id: TestDouble.getUserDictionary(1)
        ]
        let stubUserDBRepository = UserDBRepository(reference: StubUserDBReference(value: users))
        
        stubUserDBRepository.loadUsers()
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("❌ completion -> \(error)")
                }
            } receiveValue: { userList in
                XCTAssertFalse(userList.isEmpty)
            }.store(in: &subscrition)
    }
    /**
     @brief DB에서 User 리스트 데이터가 없을 때, 빈 배열로 리턴되는지 검증한다.
     - 리턴되는 데이터가 빈 배열이여야 테스트 통과
     */
    func test_loadUsers_empty(){
        var emptyUserDBRepository = UserDBRepository(reference: StubUserDBReference(value: nil))
        
        emptyUserDBRepository.loadUsers()
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("❌ completion -> \(error)")
                }
            } receiveValue: { userList in
                XCTAssertTrue(userList.isEmpty)
            }.store(in: &subscrition)
    }
        
    /**
     @brief Users/ DB구조와 다른 data 포맷이 들어올 때, 정상적으로 에러를 던지는지 검증한다.
     - 현재 db구조는 Users/ UserId값을 key값으로 유저 정보가 dic로 담겨 있다.
     - 잘못된 구조의 데이터로 검증해본다.
     - DBError.invalidate 에러를 받아야 테스트 통과
     */
    func test_loadUsers_fail(){
        let fakeUserData = TestDouble.getUserDictionary(1)
        
        let stubUserDBRepository = UserDBRepository(reference: StubUserDBReference(value: fakeUserData))
        
        stubUserDBRepository.loadUsers()
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error.localizedDescription, DBError.invalidate.localizedDescription)
                }
            } receiveValue: { userList in
                XCTFail("❌ receiveValue -> \(userList)")
            }.store(in: &subscrition)
    }
}
    
