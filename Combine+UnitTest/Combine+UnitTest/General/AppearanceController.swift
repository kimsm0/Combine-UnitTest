//
//  AppearanceController.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import Foundation

class AppearanceController: ObservableObject {
    
    @Published var appearance: AppearanceType
    
    init(_ appearanceValue: Int) {
        self.appearance = AppearanceType(rawValue:  appearanceValue) ?? .automatic
    }
    
    func changeAppearance(_ type: AppearanceType){
        appearance = type
    }
    

}
