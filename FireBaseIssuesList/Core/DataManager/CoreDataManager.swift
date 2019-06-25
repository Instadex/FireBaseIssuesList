//
//  PersistentDataManager.swift
//  FireBaseIssuesList
//
//  Created by Bharat malhotra on 24/06/19.
//  Copyright © 2019 Bharat malhotra. All rights reserved.
//

import CoreData
import RxSwift

enum EntityAttributes: String {
    case issueListentityName = "IssueList"
    case commentListEntityName = "CommentList"
    case repoName, commentPath, savedAt, listJSON
}

// MARK: - Core Data stack

class CoreDataManager {
    public static let shared = CoreDataManager()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FireBaseIssuesList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func getSavedEntity(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> NSManagedObject? {
        let managedContext = persistentContainer.viewContext
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            guard let resultValues = results,
                let result = resultValues.first else { return nil }
            return result
        } catch {
            return nil
        }
    }
    
    private func getEntityDateJSON(_ entity: NSManagedObject?) -> (Date?, String?) {
        guard let entityValue = entity else {
            return (nil, nil)
        }
        let date = entityValue.value(forKey: EntityAttributes.savedAt.rawValue) as? Date
        let jsonString = entityValue.value(forKey: EntityAttributes.listJSON.rawValue) as? String
        return (date, jsonString)
    }
    
    // MARK: Git Issues Get/Save
    private func getSavedIssuesEntity(repoName: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityAttributes.issueListentityName.rawValue)
        fetchRequest.predicate = NSPredicate(format: "\(EntityAttributes.repoName.rawValue) = %@", repoName)
        return getSavedEntity(fetchRequest: fetchRequest)
    }
    

    // It will return the tuple of date at which the json was stored
    func getSavedIssuesForRepo(_ repoName: String) -> (Date?, String?) {
        let entity = getSavedIssuesEntity(repoName: repoName)
        return getEntityDateJSON(entity)
    }
    
    //MARK: Save JSON string for repo name
    func saveIssuesForRepo(_ repoName: String, issuesJSON: String) {
        let entity = getSavedIssuesEntity(repoName: repoName)
        if let entityValue = entity {
            entityValue.setValue(repoName, forKey: EntityAttributes.repoName.rawValue)
            entityValue.setValue(Date(), forKey: EntityAttributes.savedAt.rawValue)
            entityValue.setValue(issuesJSON, forKey: EntityAttributes.listJSON.rawValue)
            saveContext(persistentContainer.viewContext)
        } else {
            let context = persistentContainer.newBackgroundContext()
            let newEntity = NSEntityDescription.insertNewObject(forEntityName: EntityAttributes.issueListentityName.rawValue, into: context)
            newEntity.setValue(repoName, forKey: EntityAttributes.repoName.rawValue)
            newEntity.setValue(Date(), forKey: EntityAttributes.savedAt.rawValue)
            newEntity.setValue(issuesJSON, forKey: EntityAttributes.listJSON.rawValue)
            saveContext(context)
        }
    }
    
    // MARK: Issue Comments Get/Save
    private func getSavedCommentsEntity(path: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityAttributes.commentListEntityName.rawValue)
        fetchRequest.predicate = NSPredicate(format: "\(EntityAttributes.commentPath.rawValue) = %@", path)
        return getSavedEntity(fetchRequest: fetchRequest)
    }
    
    // It will return the tuple of date at which the json was stored
    func getSavedCommentsForPath(_ path: String) -> (Date?, String?) {
        let entity = getSavedCommentsEntity(path: path)
        return getEntityDateJSON(entity)
    }
    
    //MARK: Saveing JSON string for Comments
    func saveCommentsForPath(_ path: String, commentsJSON: String) {
        let entity = getSavedCommentsEntity(path: path)
        if let entityValue = entity {
            entityValue.setValue(path, forKey: EntityAttributes.commentPath.rawValue)
            entityValue.setValue(Date(), forKey: EntityAttributes.savedAt.rawValue)
            entityValue.setValue(commentsJSON, forKey: EntityAttributes.listJSON.rawValue)
            saveContext(persistentContainer.viewContext)
        } else {
            let context = persistentContainer.newBackgroundContext()
            let newEntity = NSEntityDescription.insertNewObject(forEntityName: EntityAttributes.commentListEntityName.rawValue, into: context)
            newEntity.setValue(path, forKey: EntityAttributes.commentPath.rawValue)
            newEntity.setValue(Date(), forKey: EntityAttributes.savedAt.rawValue)
            newEntity.setValue(commentsJSON, forKey: EntityAttributes.listJSON.rawValue)
            saveContext(context)
        }
    }
    
    // MARK: Core Data SaveContext
    func saveContext (_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Unable to save, will save on next APICall")
                print(error.localizedDescription)
            }
        }
    }
    
    func saveChanges() {
        saveContext(persistentContainer.viewContext)
    }
}
