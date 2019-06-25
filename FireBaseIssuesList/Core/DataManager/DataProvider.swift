//
//  DateProvider.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 24/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import RxSwift
import ObjectMapper

protocol DataProviderProtocol {
    func getOpenIssuesForRepo(_ repo: String) -> Single<[FirebaseIssue]>
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]>
}

class DataProvider: DataProviderProtocol {
    let network: APINetworkProtocol!
    let persistentManager: CoreDataManager!
    
    let bag = DisposeBag()
    
    init(network: APINetworkProtocol, persistentManager: CoreDataManager) {
        self.network = network
        self.persistentManager = persistentManager
    }

    //MARK: Issuelist methods
    /*
     Get list of issues, it will check if the data is stored for more than 24 hours then it will call the API
     */
    func getOpenIssuesForRepo(_ repo: String) -> Single<[FirebaseIssue]> {
        let (date, jsonString) = persistentManager.getSavedIssuesForRepo(repo)
        guard let dateValue = date, let jsonStringValue = jsonString else {
            return self.getIssuesFromAPI(repo: repo)
        }
        
        if let diff = Calendar.current.dateComponents([.hour], from: dateValue, to: Date()).hour, diff > 24 {
            return self.getIssuesFromAPI(repo: repo)
        } else {
            let mapper = Mapper<FirebaseIssue>()
            guard let issueList = try? mapper.mapArray(JSONString: jsonStringValue) else {
                return self.getIssuesFromAPI(repo: repo)
            }
            return Single.just(issueList)
        }
    }
    
    private func getIssuesFromAPI(repo: String) -> Single<[FirebaseIssue]> {
        return network.getOpenIssuesForRepo(repo).map { (issueList) -> [FirebaseIssue] in
            if let jsonString = issueList.toJSONString() {
                self.persistentManager.saveIssuesForRepo(repo, issuesJSON: jsonString)
            }
            return issueList
        }
    }
    
    //MARK: Comments
    /*
     It will check if the data is stored for more than 24 hours then it will call the API
     */
    func getCommentsFromURL(_ commentsPath: String) -> Single<[IssueComment]> {
        let (date, jsonString) = persistentManager.getSavedCommentsForPath(commentsPath)
        guard let dateValue = date, let jsonStringValue = jsonString else {
            return self.getCommentsFromAPI(path: commentsPath)
        }
        
        if let diff = Calendar.current.dateComponents([.hour], from: dateValue, to: Date()).hour, diff > 24 {
            return self.getCommentsFromAPI(path: commentsPath)
        } else {
            let mapper = Mapper<IssueComment>()
            guard let commentList = try? mapper.mapArray(JSONString: jsonStringValue) else {
                return self.getCommentsFromAPI(path: commentsPath)
            }
            return Single.just(commentList)
        }
    }
    
    private func getCommentsFromAPI(path: String) -> Single<[IssueComment]> {
        return network.getCommentsFromURL(path).map({ (commentList) -> [IssueComment] in
            if let jsonString = commentList.toJSONString() {
                self.persistentManager.saveCommentsForPath(path, commentsJSON: jsonString)
            }
            return commentList
        })
    }
}
