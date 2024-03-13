//
//  DiskStorage.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import UIKit
import CommonCrypto

protocol DiskStorageType {
    func value(for key: String) throws -> UIImage?
    func store(for key: String, image: UIImage) throws
}

class DiskStorage: DiskStorageType {
    
    let fileManager: FileManager
    let directoryURL: URL
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache")
        createDirectory()
    }
    
    func createDirectory(){
        guard !fileManager.fileExists(atPath: directoryURL.path()) else {
            return
        }
        do{
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func cacheFileURL(for key: String) -> URL {
        let fileName = Data().sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    //key = url
    func value(for key: String) throws -> UIImage? {

        let fileURL = cacheFileURL(for: key)
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return nil
        }
        
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
        
    }
    
    //url 이미지가 memory/disk 둘다 없는 경우.
    func store(for key: String, image: UIImage) throws {
        let data = image.jpegData(compressionQuality: 0.5)
        let fileURL = cacheFileURL(for: key)
        try data?.write(to: fileURL)
    }
    
}

class StubDiskStorage: DiskStorageType {
    func value(for key: String) throws -> UIImage? {
        return nil
    }
    
    func store(for key: String, image: UIImage) throws {
        
    }
}
