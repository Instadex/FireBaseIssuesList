//
//  Application.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 22/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import UIKit

final class Application {
    public static let shared = Application()
    let networkResolver: NetworkResolverProtocol
    
    private init() {
        self.networkResolver = NetworkResolver()
    }
    
    func configureMainInterface(window: UIWindow) {
        var vc: UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "ListViewController")
        
        guard let listVC = vc as? ListViewController else {
            window.rootViewController = vc
            window.makeKeyAndVisible()
            return
        }
        let dataProvider = DataProvider(network: networkResolver.resolveAPINetwork(), persistentManager: CoreDataManager.shared)
        listVC.viewModel = ListViewModel(dataProvider: dataProvider)
        let navVC = UINavigationController(rootViewController: listVC)
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
}
