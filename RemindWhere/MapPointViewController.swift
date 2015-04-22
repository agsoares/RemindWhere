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

class MapPointViewController: UIViewController, MKMapViewDelegate {

    var dataManager: DataManager!
    var tapGestureRecognizer = UITapGestureRecognizer()
    var annotation: MKPointAnnotation!
    var note: PFObject!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer.addTarget(self, action: "tapped:")
        map.addGestureRecognizer(tapGestureRecognizer)
        dataManager = DataManager.sharedInstance
        var location = CLLocationCoordinate2D(
            latitude: dataManager.locationManager.location.coordinate.latitude,
            longitude: dataManager.locationManager.location.coordinate.longitude
        )
        
        var span = MKCoordinateSpanMake(0.5, 0.5)
        var region: MKCoordinateRegion!
        if (note["coordinate"] != nil) {
            annotation = MKPointAnnotation()
            var coordinate = note["coordinate"] as! PFGeoPoint
            annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude as CLLocationDegrees,
                coordinate.longitude as CLLocationDegrees)
            
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
            var location = CLLocation(latitude: annotation.coordinate.latitude,
                longitude: annotation.coordinate.longitude)
            var coordinate = PFGeoPoint(location: location)
            note["coordinate"] = coordinate
            note.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    var radius = NSUserDefaults.standardUserDefaults().valueForKey("AlertDistance") as! Double
                    var center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                    var region = CLCircularRegion(center: center, radius: radius*1000, identifier: self.note["title"] as! String)
                    self.dataManager.locationManager.startMonitoringForRegion(region)
                    self.performSegueWithIdentifier("returnFromMap", sender: nil)
                } else {
                    // There was a problem, check error.description
                }
            })
        }
    }

}
