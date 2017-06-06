//
//  CoreDataStack.swift
//  Skywell_FedirKorniienko
//
//  Created by Fedir Korniienko on 05.06.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import Foundation
import  CoreData
class CoreDataStack{
lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Skywell_FedirKorniienko")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
}
