/**
 @class DIContainer
 @date 3/10/24
 @writer kimsoomin
 @brief 의존성 주입을 위한 컨테이너 클래스.
 @update history
 -
 */
import Foundation

class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
