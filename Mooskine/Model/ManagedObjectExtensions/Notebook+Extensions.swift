
//
//  File.swift
//  Mooskine
//
//  Created by Victor Uriel Pacheco Garcia on 11/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Notebook {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
