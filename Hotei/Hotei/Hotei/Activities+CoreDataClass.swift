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
    
    func setAll(name: String, frequency: Int32) {
        self.name = name
        self.frequency = frequency
    }
    
    // Given the name of an activity that was done, if such activity is in the database, raise frequency by 1, else, create such instance.
    // Return the activity
    // Context has not been saved.
    static func doActivity(name: String, context: NSManagedObjectContext) -> Activities {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activities")
        request.predicate = NSPredicate(format: "name = %@", name)
        if let activity = (try? context.fetch(request))?.first as? Activities {
            activity.frequency += 1
            return activity
        }
        let newAct = Activities(context: context)
        newAct.name = name
        return newAct
    }
}
