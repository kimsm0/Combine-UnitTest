/**
 @class ChatRoomServiceTest
 @date 3/21/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import XCTest
import Combine
@testable import Combine_UnitTest

final class ChatRoomServiceTest: XCTestCase {

    private var subscription = Set<AnyCancellable>()
    private let test_myUserId = TestDouble.getString(1, key: "myUserId")
    private let test_friendUserId = TestDouble.getString(1, key: "friendUserId")
    private let test_friendUserName = TestDouble.getString(1, key: "friendUserName")
        
    
    override func setUpWithError() throws {
        subscription = Set<AnyCancellable>()
    }

    /**
     @brief DB에 전달한 데이터의 ChatRoom이 없는 경우, 새로 생성하여 DB Insert 하는 로직이 정상 호출되는지 검증한다.
     - getChatRoom과 addChatRoom 메서드가 각각 1번씩 호출되는지 검증한다.
     */
    func test_createChatRoomIfNeeded_not_existed(){
        let mockDBRepository = MockChatRoomDBRepository(mockData: nil)
        let chatRoomService = ChatRoomService(dbRepository: mockDBRepository)
        
        chatRoomService.createChatRoomIfNeeded(myUserId: test_myUserId,
                                                   friendUserId: test_friendUserName,
                                                   friendUserName: test_myUserId)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("❌ completion -> \(error)")
                }
            } receiveValue: { chatRoom in
                XCTAssertNotNil(chatRoom)
                XCTAssertEqual(1, mockDBRepository.addChatRoomCallCount)
                XCTAssertEqual(1, mockDBRepository.getChatRoomCallCount)
                
            }.store(in: &subscription)
    }
    
    func test_createChatRoomIfNeeded_existed(){
        let mockData = TestDouble.getChatRoomObject(1)
        let mockDBRepository = MockChatRoomDBRepository(mockData: mockData)
        let chatRoomService = ChatRoomService(dbRepository: mockDBRepository)
        
        chatRoomService.createChatRoomIfNeeded(myUserId: test_myUserId,
                                                   friendUserId: test_friendUserId,
                                                   friendUserName: test_friendUserName)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("❌ completion -> \(error)")
                }
            } receiveValue: { chatRoom in
                XCTAssertNotNil(chatRoom)
                XCTAssertEqual(0, mockDBRepository.addChatRoomCallCount)
                XCTAssertEqual(1, mockDBRepository.getChatRoomCallCount)
                XCTAssertEqual(chatRoom.friendUserId, self.test_friendUserId)
                XCTAssertEqual(chatRoom.friendUserName, self.test_friendUserName)
            }.store(in: &subscription)
    }

    

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
