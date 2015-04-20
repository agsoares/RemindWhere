//
//  DataManager.swift
//  RemindWhere
//
//  Created by Adriano Soares on 19/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreLocation

class DataManager: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: DataManager {
        struct Static {
            static let instance: DataManager = DataManager()
        }
        return Static.instance
    }
    
    var locationManager: CLLocationManager!
    
    var noteList: NSMutableArray = NSMutableArray()
    
    func setupLocationManager () {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        } else if (CLLocationManager.authorizationStatus() == .AuthorizedAlways) {
            self.locationManager.startUpdatingLocation()
        }
        
        var notificationTypes:UIUserNotificationType = .Alert | .Badge | .Sound
        var notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        /*
        if (locations.count > 0) {
        var location = locations[0] as! CLLocation
        for index in 0 ..< dataManager.noteList.count {
        var note = dataManager.noteList[index] as! Note
        if (note.latitude != 0 || note.latitude != 0) {
        
        var locationCoordinate = CLLocation(latitude: note.latitude as CLLocationDegrees, longitude: note.longitude as CLLocationDegrees)
        var radius = NSUserDefaults.standardUserDefaults().valueForKey("AlertDistance") as! Double
        if (locationCoordinate.distanceFromLocation(location) <= radius*1000) {
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("SendNotification") as! Bool && !note.visited) {
        note.visited = true
        var notification = UILocalNotification()
        notification.alertTitle = "RemindWhere"
        notification.alertBody = "I Just wanted to remind you of " + note.title
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        
        } else if (note.visited){
        note.visited = false
        
        }
        }
        }
        }
        */
    }
    
    
    override init() {
        super.init()
        
        var query = PFQuery(className: "Note")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        
        var err = NSErrorPointer()
        var notes = query.findObjects(err)
        if (notes != nil) {
            for note in notes! {
                noteList.addObject(note)
            }
        }
        
        
        
    }
}
