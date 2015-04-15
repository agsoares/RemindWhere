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
    var noteManager: NoteManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        map.removeAnnotations(map.annotations)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.noteManager = NoteManager.sharedInstance
            var location: CLLocationCoordinate2D!
            if (self.noteManager.locationManager.location == nil ) {
                location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            } else {
                location = CLLocationCoordinate2D(
                    latitude: self.noteManager.locationManager.location.coordinate.latitude,
                    longitude: self.noteManager.locationManager.location.coordinate.longitude
                )
            }

            var span = MKCoordinateSpanMake(0.5, 0.5)
            var region = MKCoordinateRegion(center: location, span: span)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.map.setRegion(region, animated: true)
                self.map.showsUserLocation = true;
            }
            for index in 0..<self.noteManager.noteList.count {
                var note:Note = self.noteManager.noteList[index] as! Note
                if (note.longitude != 0 && note.latitude != 0) {
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(note.latitude as CLLocationDegrees,
                        note.longitude as CLLocationDegrees)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
