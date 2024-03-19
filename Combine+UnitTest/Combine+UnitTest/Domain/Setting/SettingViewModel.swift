//
//  SettingViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import Foundation

class SettingViewModel: ObservableObject{
       
    @Published var sectionItems: [SettingSectionItem] = []
    
    init(){
        self.sectionItems = [.init(label: "모드설정", items: AppearanceType.allCases.map{ .init(item: $0) })]
    }
            
}
