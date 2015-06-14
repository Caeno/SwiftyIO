//
//  EntityDataSource+iOS.swift
//  CoreDataContext
//
//  Created by Rafael Veronezi on 12/1/14.
//  Copyright (c) 2014 Ravero. All rights reserved.
//

import CoreData

public extension EntityDataSource {
    
    /**
        Query for records on this instance and return as an NSFetchedResults Controller.
    
        - parameter predicate: The predicate used to filter records on this instance.
        - parameter sectionNameKeyPath: The section name key path to use with Fetched Results Controller.
        - parameter cacheName: The name of the cache to use with Fetched Results Controller.
        - parameter sortDescriptos: The sort descriptors to be used in the query.
        :return: A Fetched Results Controller with the resulting query.
     */
    public func getFetchedResultsController(predicate: NSPredicate? = nil, sectionNameKeyPath: String? = nil, cacheName: String? = nil, sortDescriptors: NSSortDescriptor...) -> NSFetchedResultsController {
        let request = NSFetchRequest(entityName: self.entityName)
        request.predicate = predicate
        
        if sortDescriptors.count == 0 {
            request.sortDescriptors = [ NSSortDescriptor(key: entityKeyName, ascending: true) ]
        } else {
            request.sortDescriptors = sortDescriptors
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
    }
   
    
}