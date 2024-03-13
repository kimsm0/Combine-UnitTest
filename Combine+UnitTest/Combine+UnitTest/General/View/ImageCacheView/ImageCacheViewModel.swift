//
//  ImageCacheViewModel.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/13/24.
//

import UIKit
import Combine

class ImageCacheViewModel: ObservableObject {
    
    var loadingOrSuccess: Bool {
        return isLoading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage?
    
    private var isLoading: Bool = false
    private var urlString: String
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(urlString: String, container: DIContainer) {
        self.urlString = urlString
        self.container = container
    }
    
    func start(){
        guard !urlString.isEmpty else { return }
        isLoading = true
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] image in
                self?.isLoading = false
                self?.loadedImage = image
            }.store(in: &subscription)
    }
}
