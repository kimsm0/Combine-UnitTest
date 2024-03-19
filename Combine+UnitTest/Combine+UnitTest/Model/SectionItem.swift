/**
 @class SectionItem
 @date 3/18/24
 @writer kimsoomin
 @brief 설정화면에서 사용되는 데이터 모델 정의.
 @update history
 -
 */
import Foundation

protocol SettingItemable{
    var label: String { get }
}

struct SettingSectionItem: Identifiable {
    let id = UUID()
    let label: String
    let items: [SettingItem]
}

struct SettingItem: Identifiable {
    let id = UUID()
    let item: SettingItemable
}
