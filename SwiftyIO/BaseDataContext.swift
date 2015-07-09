//
//  BaseDataContext.swift
//  CoreDataContext
//
//  Created by Rafael Veronezi on 9/30/14.
//  Copyright (c) 2014 Ravero. All rights reserved.
//

import Foundation
import CoreData

public class BaseDataContext : NSObject {
    
    //
    // MARK: - Properties
    
    var resourceName: String
    var allowAutomaticMigrations = false
    
    //
    // MARK: - Initializers
    
    public init(resourceName: String) {
        self.resourceName = resourceName
    }
    
    //
    // MARK: - Utilitarian Methods
    
    /**
        Clear the current database of this context.
     */
    public func clearDatabase() -> Bool {
        if let persistentStore = self.persistentStore {
            // First tell the persistent store coordinator that the current store will be clear.
            do {
                try self.persistentStoreCoordinator?.removePersistentStore(persistentStore)
            } catch let error as NSError {
                NSLog("Error trying to remove Persistent Store: \(error.localizedDescription)\nError data: \(error)")
                return false
            }
            
            // Delete the data files
            if let path = storeUrl.path where NSFileManager.defaultManager().fileExistsAtPath(path) {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(self.storeUrl)
                } catch let error as NSError {
                    NSLog("Error trying to remove data files: \(error.localizedDescription)\nError data: \(error)")
                    return false
                }
            }
            
            if let path = storeUrl_wal.path where NSFileManager.defaultManager().fileExistsAtPath(path) {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(self.storeUrl_wal)
                } catch let error as NSError {
                    NSLog("Error trying to remove WAL file: \(error.localizedDescription)\nError data: \(error)")
                    return false
                }
            }
            
            if let path = storeUrl_shm.path where NSFileManager.defaultManager().fileExistsAtPath(path) {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(self.storeUrl_shm)
                } catch let error as NSError {
                    NSLog("Error trying to remove SHM file: \(error.localizedDescription)\nError data: \(error)")
                    return false
                }
            }
            
            // Re-create the persistent store coordinator
            self.createPersistentStore(self.persistentStoreCoordinator!)
            return true
        }
        
        return false
    }
    
    /**
        A simple utilitarian method to print the path of the SQLite file of this instance.
     */
    public func printDatabasePath() {
        print("SwiftyIO - Model '\(resourceName)' database path: \(self.storeUrl)")
    }
    
    //
    // MARK: - Core Data Stack
    
    private var persistentStore: NSPersistentStore?
    lazy private var storeUrl: NSURL = {
        return self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.resourceName).sqlite")
    }()
    lazy private var storeUrl_wal: NSURL = {
        return self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.resourceName).sqlite-wal")
    }()
    lazy private var storeUrl_shm: NSURL = {
        return self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.resourceName).sqlite-shm")
    }()
    
    lazy private var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy private var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(self.resourceName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        if let coordinator = coordinator {
            self.createPersistentStore(coordinator)
        }
        
        return coordinator
    }()
    
    lazy public var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //
    // MARK: - Support Methods
    
    private func createPersistentStore(coordinator: NSPersistentStoreCoordinator) {
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.resourceName).sqlite")
        let failureReason = "There was an error creating or loading the application's saved data."
        
        var options: [NSObject: AnyObject]? = nil
        if allowAutomaticMigrations {
            options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
        }
        
        do {
            self.persistentStore = try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch let error as NSError {
            // Report any error we got.
            var dict = [NSObject: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            
            let customError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            fatalError("Unresolved error \(customError), \(customError.userInfo)")
        }
    }
    
    //
    // MARK: - Core Data Saving support
    
    public func saveContext() throws {
        try self.managedObjectContext?.save()
    }
    
}
