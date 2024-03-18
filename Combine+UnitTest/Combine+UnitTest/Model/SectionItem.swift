//
//  SectionItem.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import Foundation

protocol SettingItemable{
    var label: String { get }
}

struct SectionItem: Identifiable {
    let id = UUID()
    let label: String
    let settings: [SettingItem]
}

struct SettingItem: Identifiable {
    let id = UUID()
    let item: SettingItemable
}
