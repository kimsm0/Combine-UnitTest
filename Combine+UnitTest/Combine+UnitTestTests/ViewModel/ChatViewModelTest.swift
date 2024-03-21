/**
 @class ChatViewModelTest
 @date 3/21/24
 @writer kimsoomin
 @brief
 - - StubService로 DIContainer를 초기화 한 후 테스트를 진행한다.
 @update history
 -
 */
import XCTest
import Combine
@testable import Combine_UnitTest

final class ChatViewModelTest: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        
    }
    
    /**
     @brief 채팅방 화면에서 날짜로 그룹핑이 제대로 동작하는지 확인한다.
     - 전달한 테스트 데이터들의 날짜 갯수가 맞게 리턴되는지 검증한다.
     - chatDataList : 날짜로 그룹핑되어 날짜 1:1로 맵핑되는 데이터
     - chatDataList 하위 chats 배열 안에 해당 날짜의 채팅 데이터가 모두 들어가 있는지 검증한다. 
     */
    
    func test_addChat_grouping_by_date(){
        let viewModel: ChatViewModel = .init(chatRoomId: TestDouble.getString(1, key: "chatRoomId"),
                                             myUserId: TestDouble.getString(1, key: "myUserId"),
                                             friendUserId: TestDouble.getString(1, key: "friendUserId"),
                                             container: .containerWithStubService)
        
                        
        let dateComponent = DateComponents(year: 2024, month: 3, day: 20)
        let date = Calendar.current.date(from: dateComponent)!
        
        let dateComponent1 = DateComponents(year: 2024, month: 3, day: 21)
        let date1 = Calendar.current.date(from: dateComponent1)!
                
        viewModel.updateChatDataList(.init(chatId: TestDouble.getString(1, key: "chatId"),
                                           userId: TestDouble.getString(1, key: "userId"),
                                           date: date))
        viewModel.updateChatDataList(.init(chatId: TestDouble.getString(2, key: "chatId"),
                                           userId: TestDouble.getString(2, key: "userId"),
                                           date: date))
        viewModel.updateChatDataList(.init(chatId: TestDouble.getString(3, key: "chatId"),
                                           userId: TestDouble.getString(3, key: "userId"),
                                           date: date1))
        viewModel.updateChatDataList(.init(chatId: TestDouble.getString(4, key: "chatId"),
                                           userId: TestDouble.getString(4, key: "userId"),
                                           date: date1))
        
        XCTAssertEqual(viewModel.chatDataList.count, 2)
        XCTAssertEqual(viewModel.chatDataList[0].chats.count, 2)
        XCTAssertEqual(viewModel.chatDataList[1].chats.count, 2)
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
