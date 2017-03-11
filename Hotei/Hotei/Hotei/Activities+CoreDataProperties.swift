//
//  Activities+CoreDataProperties.swift
//  Hotei
//
//  Created by Akshay  on 11/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import Foundation
import CoreData


extension Activities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activities> {
        return NSFetchRequest<Activities>(entityName: "Activities");
    }

    @NSManaged public var name: String?
    @NSManaged public var history: NSSet?

}

// MARK: Generated accessors for history
extension Activities {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
