/**
 @class MemoryStorage
 @date 3/13/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import UIKit

protocol MemoryStorageType {
    func value(for key: String) -> UIImage? //get
    func store(for key: String, image: UIImage) //set
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
