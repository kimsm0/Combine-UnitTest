//
//  MemoryStorage.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import UIKit

protocol MemoryStorageType {
    func value(for key: String) -> UIImage?
    func store(for key: String, image: UIImage)
}

class MemoryStorage: MemoryStorageType {
    
    var cache = NSCache<NSString, UIImage>()
    
    func value(for key: String) ->  UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
}

class StubMemoryStorage: MemoryStorageType {
    func value(for key: String) -> UIImage? {
        return nil
    }
    
    func store(for key: String, image: UIImage) {
        
    }
}
