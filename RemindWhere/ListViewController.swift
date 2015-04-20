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
    var dataManager: DataManager!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.dataManager = DataManager.sharedInstance
            dispatch_async(dispatch_get_main_queue()) {
                self.dataManager.setupLocationManager()
                self.tableView.reloadData()
            }
        }
        
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
        var note: PFObject = sender?.object as! PFObject
        performSegueWithIdentifier("ShowMapSegue", sender: note)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:NoteTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteTableViewCell
        
        var note: PFObject = dataManager.noteList[indexPath.row] as! PFObject
        
        cell.noteTitle.text = note["title"] as! String
        cell.noteBody.text = note["body"] as! String
        cell.note = note
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataManager != nil) {
            return dataManager.noteList.count
        }
        return 0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowMapSegue") {
            var note: PFObject = sender as! PFObject
            var dvc: MapPointViewController = segue.destinationViewController as! MapPointViewController
            dvc.note = note
        }
    }
    
    @IBAction func returnToList (segue: UIStoryboardSegue) {
    }

}
