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
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    
    if CLLocationManager.authorizationStatus() == .NotDetermined {
      self.locationManager.requestAlwaysAuthorization()
    }
    
    var notificationTypes:UIUserNotificationType = .Alert | .Badge | .Sound
    var notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
  }
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
      self.locationManager.startUpdatingLocation()
      self.monitorRegions()
    }
  }
  
  func sendNotification(region: CLCircularRegion!) {
    if (NSUserDefaults.standardUserDefaults().valueForKey("SendNotification") as! Bool) {
      var notification = UILocalNotification()
      notification.alertTitle = "RemindWhere"
      notification.alertBody = "I just wanted to remind you of " + region.identifier
      notification.soundName = UILocalNotificationDefaultSoundName
      
      UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
  }
  
  
  func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
    sendNotification(region as! CLCircularRegion)
    println("ENTROU")
  }
  
  func monitorRegions() {
    var radius = NSUserDefaults.standardUserDefaults().valueForKey("AlertDistance") as! Double
    for index in 0..<noteList.count {
      let note = noteList[index] as! PFObject
      if let coordinate = note["coordinate"] as? PFGeoPoint {
        var center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        var region = CLCircularRegion(center: center, radius: radius*1000, identifier: note["title"] as! String)
        locationManager.startMonitoringForRegion(region)
      }
    }
  }
  
  func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
    println("StartLookingForRegion")
    var circularRegion = region as! CLCircularRegion
    if let location = locationManager.location {
      if (circularRegion.containsCoordinate(location.coordinate)) {
        sendNotification(region as! CLCircularRegion)
        println("TEM")
      }
    
    }
  }
  
  func removeNote(note: PFObject) {
    var predicate = NSPredicate (format: "identifier = %@", note["title"] as! String)
    var regions = locationManager.monitoredRegions as NSSet
    var filteredRegions = regions.filteredSetUsingPredicate(predicate)
    if let region = filteredRegions.first as? CLCircularRegion {
      locationManager.stopMonitoringForRegion(region)
    }
    note.deleteInBackground()
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
