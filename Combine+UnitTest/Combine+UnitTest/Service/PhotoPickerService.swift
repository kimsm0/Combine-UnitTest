//
//  PhotoPickerService.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import SwiftUI
import PhotosUI

protocol PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
}

class PhotoPickerService: PhotoPickerServiceType{
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        // TODO: 
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {
            throw PhotoPickerError.importFailed
        }
        return image.data
    }    
}

class StupPhotoPickerService: PhotoPickerServiceType{
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        return Data()
    }
}
