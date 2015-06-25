//
//  SwiftyIOTests.swift
//  SwiftyIOTests
//
//  Created by Rafael Veronezi on 25/06/15.
//  Copyright © 2015 Ravero. All rights reserved.
//

import XCTest

class SwiftyIOTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        SwiftyIOContext.sharedInstance.clients.clear()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddClient() {
        let calendar = NSCalendar()
        let components = NSDateComponents()
        components.year = 1983
        components.month = 2
        components.day = 25
        components.hour = 10
        components.minute = 30
        
        let birthday = calendar.dateFromComponents(components)
        let name = "Rafael Veronezi"
        let client1 = SwiftyIOContext.sharedInstance.clients.add {
            $0.name = name
            $0.birthday = birthday
        }
        
        XCTAssertNotNil(client1.clientId, "The new instance of the client should have an ID.")
        XCTAssertEqual(client1.name!, name)
        XCTAssertEqual(client1.birthday!, birthday!)
    }
    
}
