//
//  PhotoImage.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import Foundation
import SwiftUI

struct PhotoImage: Transferable {
    let data : Data
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image, importing: { data in
            //압축
            guard let uiImage = UIImage(data: data) else {
                throw PhotoPickerError.importFailed
            }
            
            guard let compressedData = uiImage.jpegData(compressionQuality: 0.3) else {
                throw PhotoPickerError.importFailed
            }
            
            return PhotoImage(data: compressedData)
        })
    }
}
