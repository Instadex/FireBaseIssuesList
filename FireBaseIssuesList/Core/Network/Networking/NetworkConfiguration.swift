//
//  NetworkConfiguration.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 23/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import Foundation

protocol NetworkConfigurationProtocol {
    var baseURL : String? { get set }
    func setup(baseURL: String)
}

class NetworkConfiguration : NetworkConfigurationProtocol {
    var baseURL : String?
    
    func setup(baseURL: String) {
        self.baseURL = baseURL
    }
}
