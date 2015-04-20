//
//  MapViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 07/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var dataManager: DataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        map.removeAnnotations(map.annotations)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.dataManager = DataManager.sharedInstance
            var location: CLLocationCoordinate2D!
            
            if (self.dataManager.locationManager.location == nil ) {
                location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            } else {
                location = CLLocationCoordinate2D(
                    latitude: self.dataManager.locationManager.location.coordinate.latitude,
                    longitude: self.dataManager.locationManager.location.coordinate.longitude
                )
            }
            
            var span = MKCoordinateSpanMake(0.5, 0.5)
            var region = MKCoordinateRegion(center: location, span: span)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.map.setRegion(region, animated: true)
                self.map.showsUserLocation = true;
            }
            for index in 0..<self.dataManager.noteList.count {
                var note:PFObject = self.dataManager.noteList[index] as! PFObject
                if let coordinate = note["coordinate"] as? PFGeoPoint {
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.map.addAnnotation(annotation)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
