//
//  APIRequestHandler.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 23/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import Foundation
import Alamofire


/// Sets HTTPHeader for API requests
internal class APIRequestHandler: RequestAdapter {
    var token : String?
    
    static let authKey = "Authorization"
    static let tokenPrefix = "access_token "
    static let contentTypeKey = "Content-Type"
    static let contentTypeValue = "application/json"
    static let userAgentKey = "User-Agent"
    static let userAgentValue = "Mozilla/5.0"
    
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue(APIRequestHandler.contentTypeValue, forHTTPHeaderField: APIRequestHandler.contentTypeKey)
        urlRequest.setValue(APIRequestHandler.userAgentValue, forHTTPHeaderField: APIRequestHandler.userAgentKey)
        
        return urlRequest
    }
}
