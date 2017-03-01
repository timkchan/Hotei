//
//  History+CoreDataProperties.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History");
    }

    @NSManaged public var dateTime: NSDate?
    @NSManaged public var rating: Int16
    @NSManaged public var activity: Activities?

}
