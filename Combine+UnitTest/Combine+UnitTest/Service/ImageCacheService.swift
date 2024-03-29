/**
 @class ImageCacheService
 @date 3/13/24
 @writer kimsoomin
 @brief
 1. Memory Cache를 확인
 2. Disk Cache 확인 ( File Manager)
 3. URLSession request
 @update history
 -
 */
import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

class ImageCacheService: ImageCacheServiceType{
    let memoryStorage: MemoryStorage
    let diskStorage: DiskStorage
    
    init(memoryStorage: MemoryStorage, diskStorage: DiskStorage) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        
        imageFromMemoryStorage(for: key)
            .flatMap{ image -> AnyPublisher<UIImage?, Never> in
                if let image {
                    return Just(image).eraseToAnyPublisher()
                }else {
                    return self.imageFromDiskStorage(for: key)
                }
            }.eraseToAnyPublisher()
    }
    
    func imageFromMemoryStorage(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future{[weak self] promise in
            let image = self?.memoryStorage.value(for: key)
            promise(.success(image))
        }.eraseToAnyPublisher()
    }
    
    func imageFromDiskStorage(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> {[weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
            
        }.flatMap{ image -> AnyPublisher<UIImage?, Never> in
            if let image {
                return Just(image)
                    .handleEvents(receiveOutput: {[weak self] image in
                        guard let image else { return }
                        self?.store(for: key, image: image, toDisk: false)
                    }).eraseToAnyPublisher()
            }else{
                return self.requestImageURL(for: key)
            }
        }.eraseToAnyPublisher()
    }
    
    func requestImageURL(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map{ data, _ in
                UIImage(data:  data)
            }.replaceError(with: nil)
            .handleEvents(receiveOutput: {[weak self] image in
                guard let image else { return }
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    func store(for key: String, image: UIImage, toDisk: Bool){
        memoryStorage.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

class StubimageCacheService: ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
}

