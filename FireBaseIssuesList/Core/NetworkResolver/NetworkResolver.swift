//
//  NetworkResolver.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 22/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import Foundation

protocol NetworkResolverProtocol {
    func resolveAPINetwork() -> APINetworkProtocol
}

class NetworkResolver: NetworkResolverProtocol {
    
    let SERVER_BASE_URL = APIConstants.baseUrl
    var networkClient: NetworkClientProtocol?
    
    init() { }

    func getNetworkClient() -> NetworkClientProtocol {
        if let client = self.networkClient {
            return client
        } else {
            let config = NetworkConfiguration()
            config.setup(baseURL: "\(SERVER_BASE_URL)")
            let newClient = NetworkClient(config)
            self.networkClient = newClient
            return newClient
        }
    }
    
    func resolveAPINetwork() -> APINetworkProtocol {
        return APINetwork(network: self.getNetworkClient())
    }
}
