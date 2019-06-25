//
//  APIError.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 23/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import Foundation


// Error model to handle different type of errors
public enum APIError : Error {
    case mappingFailed
    case invalidURL
    case emptyResponse
    case noContent
    case badResponse(code: Int?, desc: String?)
}

extension APIError {
    public var code: Int {
        switch self {
        case .badResponse(let code, _):
            return code ?? 0
        case .emptyResponse:
            return -1
        default:
            return 0
        }
    }
    public var description: String? {
        switch self {
        case .badResponse(_, let description):
            return description ?? ""
        default:
            return nil
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badResponse(_, let description):
            return description ?? "Error"
        default:
            return nil
        }
    }
}
