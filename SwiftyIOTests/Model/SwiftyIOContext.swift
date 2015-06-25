//
//  SwiftyIOContext.swift
//  SwiftyIO
//
//  Created by Rafael Veronezi on 25/06/15.
//  Copyright © 2015 Ravero. All rights reserved.
//

import Foundation
import SwiftyIO

class SwiftyIOContext : BaseDataContext {
    
    //
    // MARK: - Entity Data Source Properties
    
    var clients: EntityDataSource<Client, NSString>!
    
    //
    // MARK: - Singleton
    
    class var sharedInstance: SwiftyIOContext {
        struct Singleton {
            static var instance: SwiftyIOContext?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Singleton.token) {
            Singleton.instance = SwiftyIOContext()
        }
        
        return Singleton.instance!
    }
    
    //
    // MARK: - Initializers
    
    init() {
        super.init(resourceName: "SwiftyIO")
        
        if let moc = self.managedObjectContext {
            clients = EntityDataSource(managedObjectContext: moc, entityName: "Client", entityKeyName: "clientId", entityKeyGeneration: .UUID)
        }
    }
    
}