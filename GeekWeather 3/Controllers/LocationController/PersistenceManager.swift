//
//  SavedLocationViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/6/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import CoreData
import Foundation

final class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
   
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func delete(item: SavedLocation) {
        let context = persistentContainer.viewContext
        context.delete(item)
        try? context.save()
    }
    
    func deleteAll() {
        let savedItems = fetch(SavedLocation.self)
        
        savedItems.forEach { (item) in
            let context = persistentContainer.viewContext
            context.delete(item)
            
            try? context.save()
        }
    }
    
    func save() {
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
   
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
            
        } catch {
            print(error)
            return [T]()
        }
        
    }
}
