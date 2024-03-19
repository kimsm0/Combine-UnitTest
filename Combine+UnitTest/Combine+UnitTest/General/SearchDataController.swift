/**
 @class SearchDataController
 @date 3/18/24
 @writer kimsoomin
 @brief  CoreData에 저장된 최근 검색어 데이터 로드 싱글톤 클래스 
 @update history
 -
 */
import Foundation
import CoreData

class SearchDataController: ObservableObject {
    let persistantContainer = NSPersistentContainer(name: "Search")
    
    init(){
        persistantContainer.loadPersistentStores { description, error in
        
            if let error {
                print("Core Data Failed!! \(error)")
            }
        }
    }
}
