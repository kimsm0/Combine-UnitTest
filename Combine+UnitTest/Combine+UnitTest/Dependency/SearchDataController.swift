/**
 @class SearchDataController
 @date 3/18/24
 @writer kimsoomin
 @brief  CoreData에 저장된 최근 검색어 데이터 로드 싱글톤 클래스 
 @update history
 - DIContainer 에서 관리할 수 있도록 리팩토링 진행
 */
import Foundation
import CoreData

protocol DataControllable {
    var persistantContainer: NSPersistentContainer { get set }
}

class SearchDataController: DataControllable {
    var persistantContainer = NSPersistentContainer(name: "Search")
    
    init(){
        persistantContainer.loadPersistentStores { description, error in
        
            if let error {
                print("Core Data Failed!! \(error)")
            }
        }
    }
}
