//
//  DataController.swift
//  Mooskine
//
//  Created by Victor Uriel Pacheco Garcia on 11/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storedDescription, error in
            guard error == nil else { fatalError(error!.localizedDescription) }
        }
        self.autoSaveViewContext()
        self.configureContexts()
        completion?()
    }
}

extension DataController {
    func autoSaveViewContext(interval: TimeInterval = 30) {
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: {
            self.autoSaveViewContext()
        })
    }
}
