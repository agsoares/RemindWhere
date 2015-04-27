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

class MapViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var map: MKMapView!
  var dataManager: DataManager!
  
  var selectedTintColor = (UIApplication.sharedApplication().delegate as! AppDelegate).selectedTintColor
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    map.removeAnnotations(map.annotations)
    map.removeOverlays(map.overlays)
    
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    dispatch_async(dispatch_get_global_queue(priority, 0)) {
      self.dataManager = DataManager.sharedInstance
      var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
      
      if let locationManager = self.dataManager.locationManager {
        if let userLocation = locationManager.location {
          location = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
          )
        }
      }
      
      var span = MKCoordinateSpanMake(0.5, 0.5)
      var region = MKCoordinateRegion(center: location, span: span)
      
      dispatch_async(dispatch_get_main_queue()) {
        self.map.delegate = self
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true;
      }
      var radius = NSUserDefaults.standardUserDefaults().valueForKey("AlertDistance") as! Double
      for index in 0..<self.dataManager.noteList.count {
        var note:PFObject = self.dataManager.noteList[index] as! PFObject
        if let coordinate = note["coordinate"] as? PFGeoPoint {
          var annotation = MKPointAnnotation()
          var center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
          annotation.coordinate = center
          dispatch_async(dispatch_get_main_queue()) {
            var circle = MKCircle(centerCoordinate: center, radius: radius*1000)
            
            self.map.addOverlay(circle)
            self.map.addAnnotation(annotation)
          }
        }
      }
    }
  }
  
  func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    var circleRenderer = MKCircleRenderer(overlay: overlay)
    circleRenderer.strokeColor = selectedTintColor
    circleRenderer.fillColor = selectedTintColor.colorWithAlphaComponent(0.5)
    return circleRenderer
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
