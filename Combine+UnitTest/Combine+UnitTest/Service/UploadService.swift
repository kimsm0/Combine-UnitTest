//
//  UploadService.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import Combine

enum UploadsourceType {
    case chat(chatRoomId: String)
    case profile(userId: String)
    
    var path: String {
        switch self {
        case let .chat(chatRoomId):
            return "\(DBKey.Chats)/\(chatRoomId)"
        case let .profile(userId):
            return "\(DBKey.Users)/\(userId)"
        }
    }
}

protocol UploadServiceType {
    func uploadImage(source: UploadsourceType, data: Data) -> AnyPublisher<URL, ServiceError>
    func uploadImage(source: UploadsourceType, data: Data) async throws -> URL
}

class UploadService: UploadServiceType {
    private var provider: UploadProviderType
    
    init(provider: UploadProviderType) {
        self.provider = provider
    }
    
    func uploadImage(source: UploadsourceType, data: Data) async throws -> URL {
        let url = try await provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
        return url
    }
    
    func uploadImage(source: UploadsourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
            .mapError{ ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
}

class StupUploadService: UploadServiceType {
    
    func uploadImage(source: UploadsourceType, data: Data) async throws -> URL {
        return URL(string: "")!
    }
    
    func uploadImage(source: UploadsourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
