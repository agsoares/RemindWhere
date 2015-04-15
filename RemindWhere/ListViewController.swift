//
//  ListViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 07/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var noteManager: NoteManager!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.noteManager = NoteManager.sharedInstance
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        setupLocationManager()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "addLocation:",
            name: "addLocationNotification",
            object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    
    }
    
    func addLocation(sender: NSNotification?) {
        var note: Note = sender?.object as! Note
        performSegueWithIdentifier("ShowMapSegue", sender: note)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:NoteTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteTableViewCell
        
        cell.noteTitle.text = (noteManager.noteList[indexPath.row] as! Note).title
        cell.noteBody.text = (noteManager.noteList[indexPath.row] as! Note).body
        cell.note = noteManager.noteList[indexPath.row] as! Note
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(noteManager != nil) {
            return noteManager.noteList.count
        }
        return 0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowMapSegue") {
            var note: Note = sender as! Note
            var dvc: MapPointViewController = segue.destinationViewController as! MapPointViewController
            dvc.note = note
        }
    }
    
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
        if (locations.count > 0) {
            var location = locations[0] as! CLLocation
            for index in 0 ..< noteManager.noteList.count {
                var note = noteManager.noteList[index] as! Note
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
    }
    
    @IBAction func returnToList (segue: UIStoryboardSegue) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
