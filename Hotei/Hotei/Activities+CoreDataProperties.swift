//
//  Activities+CoreDataProperties.swift
//  Hotei
//
//  Created by Nick Robertson on 14/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import Foundation
import CoreData


extension Activities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activities> {
        return NSFetchRequest<Activities>(entityName: "Activities");
    }

    @NSManaged public var name: String?

}
