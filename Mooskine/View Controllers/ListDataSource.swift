//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Victor Uriel Pacheco Garcia on 11/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

protocol Identifiable {}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: Identifiable {}

class ListDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let tableView: UITableView
    let managedObjectContext: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<ObjectType>!
    let configure: (CellType, ObjectType) -> Void
    
    fileprivate func setupFetchResultController() {
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        self.tableView.dataSource = self
    }
    
    init(tableView: UITableView,
         managedObjectContext: NSManagedObjectContext,
         fetchRequest:  NSFetchRequest<ObjectType>,
         configure: @escaping (CellType, ObjectType) -> Void) {
        self.configure = configure
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: managedObjectContext,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)
        super.init()
        setupFetchResultController()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as! CellType
        
        // Configure cell
        configure(cell, object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteObject(at: indexPath)
        default: () // Unsupported
        }
    }
    
    func deleteObject(at indexPath: IndexPath) {
        let noteToDelete = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(noteToDelete)
        try? managedObjectContext.save()
    }
    
    func updateEditButtonState() {
        if let sections = fetchedResultsController.sections {
            //TODO: UPDATE
//            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func object(at indexPath: IndexPath) -> ObjectType {
        return fetchedResultsController.object(at: indexPath)
    }
}
