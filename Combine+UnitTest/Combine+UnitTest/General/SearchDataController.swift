//
//  SearchDataController.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

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
