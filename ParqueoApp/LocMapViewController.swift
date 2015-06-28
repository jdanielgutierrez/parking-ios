//
//  LocMapViewController.swift
//  ParqueoApp
//
//  Created by internet on 6/25/15.
//  Copyright (c) 2015 internet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class LocMapViewController: UIViewController, CLLocationManagerDelegate
{

    @IBOutlet weak var mapParking: MKMapView!
    var myList:Array<AnyObject> = []
    
    var location = Location(latitude: "0",longitude: "0")
    var counter = 0
    
  
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.mapParking.delegate = self
        
        println("Entro Geolocalizacion")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refresh(sender: AnyObject) {
        
        println("Entro button refresh")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()
        
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        
        let currentLocation = CLLocationCoordinate2D(latitude: placemark.location.coordinate.latitude,longitude: placemark.location.coordinate.longitude)
        
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: currentLocation, span: span)
        
        mapParking.setRegion(region, animated: true)
        
        
        let auxAnnotation = MyAnnotation(coordinate: currentLocation,
            title: "My location",
            subtitle: "")
        
        
        mapParking.addAnnotation(auxAnnotation)
        
        
        //fetch parkings
        
        println("Load Parkings....")
        // Dispose of any resources that can be recreated.
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest (entityName: "Parking")
        
        myList = context.executeFetchRequest(freq, error: nil)!
        
        for resultItem in myList
        {
            var parkingItem = resultItem as Parking
            
            let auxLocation = CLLocationCoordinate2D(latitude: (parkingItem.latitude as NSString).doubleValue,longitude: (parkingItem.longitude as NSString).doubleValue)
            
            let auxAnnotation = MyAnnotation(coordinate: auxLocation,
                title: parkingItem.address,
                subtitle: parkingItem.schedule + "  Rate " + parkingItem.rate + " Bs.",
                pinColor: .Green)
            
            mapParking.addAnnotation(auxAnnotation)
            
        }

        
    }

    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error: " + error.localizedDescription)
        
    }
    
    
}

extension LocMapViewController: MKMapViewDelegate {
    func mapView(mapParking: MKMapView!, viewForAnnotation annotation: MKAnnotation!)-> MKAnnotationView!{
        if annotation is MyAnnotation == false{
            return nil
        }
        
        /* First typecast the annotation for which the Map View has
        fired this delegate message */
        let senderAnnotation = annotation as MyAnnotation
        
        /* We will attempt to get a reusable
        identifier for the pin we are about to create */
        let pinReusableIdentifier = senderAnnotation.pinColor.rawValue
        
        /* Using the identifier we retrieved above, we will
        attempt to reuse a pin in the sender Map View */
        var annotationView =
        mapParking.dequeueReusableAnnotationViewWithIdentifier(
            pinReusableIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil{
            /* If we fail to reuse a pin, then we will create one */
            annotationView = MKPinAnnotationView(annotation: senderAnnotation,
                reuseIdentifier: pinReusableIdentifier)
            
            /* Make sure we can see the callouts on top of
            each pin in case we have assigned title and/or
            subtitle to each pin */
            annotationView!.canShowCallout = true
        }
        
        if senderAnnotation.pinColor == .Blue{
            let pinImage = UIImage(named:"BluePin")
            annotationView!.image = pinImage
        } else {
            annotationView!.pinColor = senderAnnotation.pinColor.toPinColor()
        }
        
        return annotationView
        
    }


}