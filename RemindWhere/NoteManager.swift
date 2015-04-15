//
//  NoteManager.swift
//  RemindWhere
//
//  Created by Adriano Soares on 08/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class NoteManager: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: NoteManager {
        struct Static {
            static let instance: NoteManager = NoteManager()
        }
        return Static.instance
    }
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    var noteList: NSMutableArray = NSMutableArray()
    
    override init() {
        super.init()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext: NSManagedObjectContext! = appDelegate.managedObjectContext
        var err: NSErrorPointer = nil
        
        var fetchRequest = NSFetchRequest(entityName: "Note")
        
        
        noteList = NSMutableArray(array: managedObjectContext.executeFetchRequest(fetchRequest, error: err)!)

    }
    


    
}
