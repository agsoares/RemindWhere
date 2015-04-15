//
//  Note.swift
//  RemindWhere
//
//  Created by Adriano Soares on 07/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import Foundation
import CoreData

@objc(Note)

class Note: NSManagedObject {
    var visited = false
    
    
    @NSManaged var title: String
    @NSManaged var body: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}
