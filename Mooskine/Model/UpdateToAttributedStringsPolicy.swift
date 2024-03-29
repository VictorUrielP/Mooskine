//
//  UpdateToAttributedStringsPolicy.swift
//  Mooskine
//
//  Created by Victor Uriel Pacheco Garcia on 11/4/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class UpdateToAttributedStringsPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        // Call super
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        // Get the (updated) destination Note instance we're modifying
        guard let destination = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance]).first else { return }
        
        // Use the (original) source Note instance, and instantiate a new
        // NSAttributedString using the original string
        if let text = sInstance.value(forKey: "text") as? String {
            destination.setValue(NSAttributedString(string: text), forKey: "attributedText")
        }
    }
}

