//
//  Activities+CoreDataClass.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import Foundation
import CoreData


public class Activities: NSManagedObject {
    
    func setAll(name: String) {
        self.name = name

        
    }
    
    // Given the name of an activity that was done, if such activity is in the database, raise frequency by 1, else, create such instance.
    // Return the activity
    // Context has not been saved.
    static func doActivity(name: String, context: NSManagedObjectContext) -> Activities {
        let newAct = Activities(context: context)
        newAct.name = name
        return newAct
    }
}
