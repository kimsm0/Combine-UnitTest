//
//  DBError.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/11/24.
//

import Foundation

enum DBError: Error{
    case error(Error)
    case emptyValue
}
