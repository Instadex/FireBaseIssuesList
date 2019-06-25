//
//  APINetwork.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 23/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import Foundation
import RxSwift

protocol APINetworkProtocol {
    func getOpenIssuesForRepo(_ repo: String) -> Single<[FirebaseIssue]>
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]>
}

class APINetwork : APINetworkProtocol {
    
    let network : NetworkClientProtocol
    
    init(network: NetworkClientProtocol) {
        self.network = network
    }
    
  // Getting list of firebase issues from API
    func getOpenIssuesForRepo(_ repo: String) -> Single<[FirebaseIssue]> {
        let r = APIRequest(method: .get, path: "/repos/\(repo)/issues")
        return network.request(r)
    }
    
    // Getting comments from API
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]> {
        let r = APIRequest(method: .get, path: commentsPath)
        return network.request(r)
    }
}
