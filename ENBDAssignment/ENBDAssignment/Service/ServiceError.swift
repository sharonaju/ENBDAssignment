//
//  ServiceError.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import Foundation

enum ServiceError: Error {
      case noInternetConnection
      case custom(String)
      case other
  }

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
        }
    }
}
extension ServiceError {
    init(json: JSON) {
        if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}
