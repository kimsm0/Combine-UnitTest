//
//  ContactService.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation
import Combine
import Contacts

protocol ContactServiceType{
    func fetchContacts() -> AnyPublisher<[User], ServiceError>
}


class ContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Future{ [weak self] promise in
            self?.fetchContacts(completion: {
                promise($0)
            })
        }
        .mapError{.error($0)}        
        .eraseToAnyPublisher()
    }
    
    private func fetchContacts(completion: @escaping( Result<[User], Error>) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {[weak self] granted, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard granted else {
                completion(.failure(ContactError.permissionDenied))
                return
            }
            
            self?.fetchContacts(store: store, completion: completion)
        })
    }
    
    private func fetchContacts(store: CNContactStore, completion: @escaping( Result<[User], Error>) -> Void){
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        let request = CNContactFetchRequest(keysToFetch: keyToFetch)
        
        var users: [User] = []
        
        do {
            try store.enumerateContacts(with: request, usingBlock: { contact, _ in
                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                
                let user: User = .init(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
                users.append(user)
            })
            completion(.success(users))
        }catch {
            completion(.failure(error))
        }
        
    }
}

class StubContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
