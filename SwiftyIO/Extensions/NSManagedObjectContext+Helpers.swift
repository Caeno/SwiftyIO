//
//  NSManagedObjectContext+Helpers.swift
//  CoreDataContext
//
//  Created by Rafael Veronezi on 9/30/14.
//  Copyright (c) 2014 Syligo. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObjectContext {
    
    /**
        Saves the current Managed Object context using default error handling
     */
    func persistModel() {
        do {
            try self.save()
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            fatalError("Unresolved error \(error), \(error.userInfo).")
        }
    }
    
}