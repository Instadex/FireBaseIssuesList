//
//  IssueListCell.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 23/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import UIKit

class IssueListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyLabel.textColor = .darkGray
    }
    
    func fillIssueData(_ issue: FirebaseIssue) {
        titleLabel.text = issue.title
        bodyLabel.text = String(issue.body?.prefix(APIConstants.bodyTextLength) ?? "")
        accessoryType = issue.commentsCount == 0 ? .none : .disclosureIndicator
    }
    
    func fillCommentData(_ comment: IssueComment) {
        titleLabel.text = comment.user?.loginName
        bodyLabel.text = comment.body
    }
}
