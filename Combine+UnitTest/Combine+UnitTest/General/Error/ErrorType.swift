/**
 @class ErrorType
 @date 3/12/24
 @writer kimsoomin
 @brief 앱 전체에서 사용되는 에러 타입 열거형을 서비스 별로 정의.
 @update history
 -
 */
import Foundation

// MARK: 로그인 로직에서 사용
enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invalidated
}

// MARK: DB 접근시 사용
enum DBError: Error{
    case error(Error)
    case emptyValue
    case invalidate
    case decodingError
    case encodingError
}

// MARK: Service Layer에서 공통으로 사용
enum ServiceError: Error{
    case error(Error)
}

// MARK: 연락처 연동 로직에서 사용
enum ContactError: Error{
    case permissionDenied
    
}

// MARK: PhotoPicker 연동 로직에서 사용
enum PhotoPickerError: Error {
    case importFailed
}

// MARK: Data Upload 로직에서 사용 
enum UploadError: Error {
    case uploadError(Error)
}
