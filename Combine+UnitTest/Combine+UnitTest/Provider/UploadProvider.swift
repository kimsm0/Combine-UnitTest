//
//  UploadProvider.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseStorageCombineSwift

protocol UploadProviderType{
    func upload(path: String, data: Data, fileName: String)  -> AnyPublisher<URL, UploadError>
    func upload(path: String, data: Data, fileName: String) async throws -> URL
}

class UploadProvider:  UploadProviderType {
    let storageRef = Storage.storage().reference() // cloud file을 가리키는 포인터
    
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        let ref = storageRef.child(path).child(fileName)
        let _ = try await ref.putDataAsync(data)
        let url = try await ref.downloadURL()
        
        return url
    }
    
    func upload(path: String, data: Data, fileName: String) -> AnyPublisher<URL, UploadError> {
        let ref = storageRef.child(path).child(fileName)
        
        return ref.putData(data)
            .flatMap{ _ in
                ref.downloadURL()
            }.mapError{ UploadError.uploadError($0) }
            .eraseToAnyPublisher()
        
    }
}
