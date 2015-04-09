//
//  EntityDataSource.swift
//  CoreDataContext
//
//  Created by Rafael Veronezi on 9/30/14.
//  Copyright (c) 2014 Syligo. All rights reserved.
//

import Foundation
import CoreData

public enum PrimaryKeyGeneration<K: AnyObject> {
    case None
    case AutoNumber
    case UUID
    case Custom(() -> (K))
}

/**
    EntityDataSource<T>

    This class allows access and data operations on an entity represented by NSManagedObject type T.
    Use this to facilitate data operation against the entity.
 */
public class EntityDataSource<T: NSManagedObject, K: AnyObject> {
    
    //
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext
    var entityName: String
    var entityKeyName: String
    var entityKeyGeneration: PrimaryKeyGeneration<K> = .None
    
    //
    // MARK: - Initializers
    
    /**
        Initialize a new instance of this class with the required parameters
    
        :param: managedObjectContext The Managed Object Context that this instance use to operates against the Core Data repository
        :param: entityName The name of entity being sourced by this instance
        :param: entityKeyName The name of the Primary key column in the entity
    */
    public init(managedObjectContext: NSManagedObjectContext, entityName: String, entityKeyName: String) {
        self.managedObjectContext = managedObjectContext
        self.entityName = entityName
        self.entityKeyName = entityKeyName
    }
    
    /**
        Initialize a new instance of this class with the required parameters
        
        :param: managedObjectContext The Managed Object Context that this instance use to operates against the Core Data repository
        :param: entityName The name of entity being sourced by this instance
        :param: entityKeyName The name of the Primary key column in the entity
        :param: entityKeyGeneration The type of Key Generation to be used
    */
    public convenience init(managedObjectContext: NSManagedObjectContext, entityName: String, entityKeyName: String, entityKeyGeneration: PrimaryKeyGeneration<K>) {
        self.init(managedObjectContext: managedObjectContext, entityName: entityName, entityKeyName: entityKeyName)
        self.entityKeyGeneration = entityKeyGeneration
    }
    
    
    
    //
    // MARK: - Methods to manage the entity
    
    /**
        Add a new record to the this entity set.
    
        :param: configureBlock The block used to configure entity parameters before it is persisted.
        :returns: The newly configured object.
     */
    public func add(configureBlock: ((T) -> ())?) -> T {
        let newRecord = self.create()
        configureBlock?(newRecord)
        self.managedObjectContext.save()
        
        return newRecord
    }
    
    /**
        Clear all entries on this entity set.
     */
    public func clear() {
        let items = self.getAll()
        for item in items {
            self.managedObjectContext.deleteObject(item)
        }
        
        self.managedObjectContext.save()
    }
    
    /**
        Count the total number of rows in this entity.
    
        :returns: The count of rows.
     */
    public func count() -> Int {
        return self.count(nil)
    }
    
    /**
        Count the number of rows in this entity using the specified predicate.
    
        :param: predicate The predicate to be used for count operation.
        :returns: The count of rows.
     */
    public func count(predicate: NSPredicate?) -> Int {
        let request = NSFetchRequest(entityName: self.entityName)
        request.predicate = predicate
        
        var error: NSError?
        return self.managedObjectContext.countForFetchRequest(request, error: &error)
    }
    
    /**
        Creates a new record for this entity set associated with the current NSManagedObjectContext.
    
        :returns: The new record object.
     */
    public func create() -> T {
        let newRecord = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedObjectContext) as! T
        
        // Check the key generation type
        switch self.entityKeyGeneration {
        case .None:
            break
        case .AutoNumber:
            let nextValue = self.count() + 1
            newRecord.setValue(nextValue, forKey: self.entityKeyName)
        case .UUID:
            newRecord.setValue(NSUUID().UUIDString, forKeyPath: self.entityKeyName)
        case .Custom(let keyFunc):
            newRecord.setValue(keyFunc(), forKey: self.entityKeyName)
        }
        
        return newRecord
    }
    
    /**
        Deletes a record from this entity set.
    
        :param: recordId The ID of the record to be deleted. If no record is found with this ID nothing is done.
        :returns: True if the record could be deleted.
     */
    public func delete(recordId: K) -> Bool {
        if let record = find(recordId) {
            self.managedObjectContext.deleteObject(record)
            self.managedObjectContext.save()
            return true
        }
        
        return false
    }
    
    /**
        Get an array of All record from this entity set.
        Note: This method does not implement any sort of caching, so it wisely.
    
        :returns: An array with all entity objects.
     */
    public func getAll(sortDescriptors: NSSortDescriptor...) -> [T] {
        var request = NSFetchRequest(entityName: self.entityName)
        request.sortDescriptors = sortDescriptors
        var error: NSError?
        
        return self.managedObjectContext.executeFetchRequest(request, error: &error) as! [T]
    }
    
    /**
        Find a record by its ID.
    
        :param: recordId The ID of the record being sought.
        :returns: The sought record or nil if not found on database.
     */
    public func find(recordId: K) -> T? {
        var request = NSFetchRequest(entityName: self.entityName)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [ self.entityKeyName, recordId ])
        
        var error: NSError?
        var matches = self.managedObjectContext.executeFetchRequest(request, error: &error) as! [T]?
        return matches?.first
    }

    /**
        Return the first record of a fetch request using the specified predicate/sort descriptors.
    
        :param: predicate The predicate to be used in filter
        :param: sortDescriptors An optional array of sort descriptors
        :returns: The first record that obeys the predicate/sort descriptors
     */
    public func first(predicate: NSPredicate? = nil, sortDescriptors: NSSortDescriptor...) -> T? {
        var request = NSFetchRequest(entityName: self.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = 1
        
        var error: NSError?
        let results = self.managedObjectContext.executeFetchRequest(request, error: &error) as! [T]?
        return results?.first
    }
    
    /**
        Filter a result by a predicate sorted by descriptors.
    
        :param: predicate The predicate to be used in filter
        :param: sortDescriptors An optional array of sort descriptors
        :returns: An array with entities that match the specified predicate, sorted by the descriptors
     */
    public func filter(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        var request = NSFetchRequest(entityName: self.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        var error: NSError?
        return self.managedObjectContext.executeFetchRequest(request, error: &error) as! [T]?
    }
    
    /**
        Updates an record by it's ID.
        
        :param: recordId The ID of the record to be updated.
        :param: configureBlock The block that is called to configure the updates.
     */
    public func update(recordId: K, configureBlock: (T) -> ()) -> T? {
        if var record = find(recordId) {
            configureBlock(record)
            self.managedObjectContext.save()
            return record
        }
        
        return nil
    }
    
}
