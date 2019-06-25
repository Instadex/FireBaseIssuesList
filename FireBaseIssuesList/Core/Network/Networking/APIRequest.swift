//
//  APIRequest.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 23/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import Foundation
import Alamofire


struct APIRequest {
    let method: HTTPMethod
    let path: String
    let parameters: [String: Any]
    let parametersArray: [Any]?
    
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
        self.parameters = [:]
        self.parametersArray = nil
    }
    
    init(method: HTTPMethod, path: String, parameters: [String: Any]) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.parametersArray = nil
    }
    
    init(method: HTTPMethod, path: String, parametersArray: [Any]) {
        self.method = method
        self.path = path
        self.parameters = [:]
        self.parametersArray = parametersArray
    }
}
