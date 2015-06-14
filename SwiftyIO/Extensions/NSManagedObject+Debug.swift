//
//  NSManagedObject+Debug.swift
//  CoreDataContext
//
//  Created by Rafael Veronezi on 5/1/15.
//  Copyright (c) 2015 Ravero. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {

    private func buildDebugString() -> String {
        let entityName = entity.name ?? "Unknown"
        var result = "Entity Name: \(entityName)"
        
        result += "\nAttributes: {"
        for (name, attr) in entity.attributesByName {
            result += "\n\t\(name): \(valueForKey(name as! String))"
        }
        result += "\n}"
        
        return result
    }
    
    /**
        Return instance information for Xcode Debug Preview feature, entity name and managed attributes and values.
     */
    func debugQuickLookObject() -> AnyObject {
        return buildDebugString()
    }
    
}