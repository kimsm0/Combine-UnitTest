//
//  SettingViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import Foundation

class SettingViewModel: ObservableObject{
       
    @Published var sectionItems: [SectionItem] = []
    
    init(){
        self.sectionItems = [.init(label: "모드설정", settings: AppearanceType.allCases.map{ .init(item: $0) })]
    }
            
}
