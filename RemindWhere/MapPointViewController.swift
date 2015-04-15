//
//  MapPointViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 08/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapPointViewController: UIViewController {

    var noteManager: NoteManager!
    var tapGestureRecognizer = UITapGestureRecognizer()
    var annotation: MKPointAnnotation!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var note: Note!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        tapGestureRecognizer.addTarget(self, action: "tapped:")
        map.addGestureRecognizer(tapGestureRecognizer)
        noteManager = NoteManager.sharedInstance
        var location = CLLocationCoordinate2D(
            latitude: noteManager.locationManager.location.coordinate.latitude,
            longitude: noteManager.locationManager.location.coordinate.longitude
        )
        
        var span = MKCoordinateSpanMake(0.5, 0.5)
        var region: MKCoordinateRegion!
        if (note.latitude != 0 && note.longitude != 0) {
            annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(note.latitude as CLLocationDegrees,
                note.longitude as CLLocationDegrees)
            map.addAnnotation(annotation)
            region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        } else {
            region = MKCoordinateRegion(center: location, span: span)
        }
        
        map.setRegion(region, animated: true)
        map.showsUserLocation = true;
        // Do any additional setup after loading the view.
    }

    func tapped(gesture: UITapGestureRecognizer) {
        if (annotation == nil) {
            annotation = MKPointAnnotation()
        } else {
            map.removeAnnotation(annotation)
        }
        
        var touchPoint = gesture.locationInView(map)
        var touchCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: map)
        annotation.coordinate = touchCoordinate
        
        map.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        if (annotation != nil) {
            note.latitude = annotation.coordinate.latitude
            note.longitude = annotation.coordinate.longitude
            
            var err: NSErrorPointer = nil
            managedObjectContext.save(err)
            if(err != nil) {
            }
            performSegueWithIdentifier("returnFromMap", sender: nil)
        }
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
