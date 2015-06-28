//
//  MapViewController.swift
//  ParqueoApp
//
//  Created by internet on 5/22/15.
//  Copyright (c) 2015 internet. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapParking: MKMapView!
    
    var onDataAvailable : ((data: Location) -> ())?
    
    var location = Location(latitude: "0",longitude: "0")
    var counter = 0
    
    var toLongitude:String!
    var toLatitude:String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (toLongitude.isEmpty || toLongitude==nil) && (toLatitude.isEmpty || toLatitude==nil)
        {
            let locationIni = CLLocationCoordinate2D(latitude: -17.3895,longitude: -66.1568)
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: locationIni, span: span)
            
            mapParking.setRegion(region, animated: true)
        }
        else
        {
            let MomentaryLatitude = (toLatitude as NSString).doubleValue
            let MomentaryLongitude = (toLongitude as NSString).doubleValue
            
            let locationIni = CLLocationCoordinate2D(latitude: MomentaryLatitude,longitude: MomentaryLongitude)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: locationIni, span: span)
        
            mapParking.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.setCoordinate(locationIni)
            annotation.title = "Parking"
            annotation.subtitle = ""
            
            mapParking.addAnnotation(annotation)
        
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
        mapParking.addGestureRecognizer(longPress)
        
       
    }
    

    func action(gestureRecognizer:UIGestureRecognizer) {
        var touchPoint = gestureRecognizer.locationInView(self.mapParking)
        var newCoord:CLLocationCoordinate2D = mapParking.convertPoint(touchPoint, toCoordinateFromView: self.mapParking)
        
        if (counter==0)
        {
            var newAnotation = MKPointAnnotation()
            newAnotation.coordinate = newCoord
            newAnotation.title = "New Parking"
            newAnotation.subtitle = ""
            mapParking.addAnnotation(newAnotation)
        
            println(newAnotation.coordinate.latitude)
            println(newAnotation.coordinate.longitude)

            location = Location(latitude: String(format: "%f",newAnotation.coordinate.latitude), longitude: String(format: "%f",newAnotation.coordinate.longitude))
            
            counter++

        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(false, completion: nil)
        println("cancel")
    }
    
    @IBAction func deleteAnnotations(sender: AnyObject) {
        let annotationsToRemove = mapParking.annotations.filter { $0 !== self.mapParking.userLocation }
        mapParking.removeAnnotations( annotationsToRemove )
        counter=0
        println("deleted")
    }
    
    @IBAction func done(sender: AnyObject) {
        
        if (mapParking.annotations.count>0)
        {
            sendData(location)
        }
            
        navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(false, completion: nil)
        println("done")
        
    }
    
    
    func sendData(data: Location) {
        // Whenever you want to send data back to viewController1, check
        // if the closure is implemented and then call it if it is
        self.onDataAvailable?(data: data)
    }

    
}
