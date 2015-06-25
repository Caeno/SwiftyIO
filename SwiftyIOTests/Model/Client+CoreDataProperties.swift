//
//  Client+CoreDataProperties.swift
//  SwiftyIO
//
//  Created by Rafael Veronezi on 25/06/15.
//  Copyright © 2015 Ravero. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Client {

    @NSManaged var clientId: String?
    @NSManaged var name: String?
    @NSManaged var birthday: NSDate?

}
