//
//  RiderViewController.swift
//  Uber_yesh
//
//  Created by Yeswanth varma Kanumuri on 1/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class RiderViewController: UIViewController ,CLLocationManagerDelegate ,MKMapViewDelegate {

    @IBOutlet weak var calluberbutton: UIButton!
 
    @IBOutlet  var map: MKMapView!
    
   var uberRequested = false
    
    var locationManager:CLLocationManager!
    
    var lat :CLLocationDegrees = 0
    var long :CLLocationDegrees = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        var location:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.lat = location.latitude
        self.long = location.longitude
        
        // print("Locations : \(lat) , \(long)")
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        self.map.removeAnnotations(map.annotations)
        
        var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
        
        var objectAnnotation = MKPointAnnotation()
        
        objectAnnotation.coordinate = pinLocation
        
        objectAnnotation.title = "current location"
        
        self.map.addAnnotation(objectAnnotation)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        
        // Dispose of any resources that can be recreated.
    }
    

  

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "logoutRider" {
        
        PFUser.logOut()
        
        
        }
        
        
        
    }
    
    
    
    @IBAction func callforUber(sender: AnyObject) {
        
       if self.uberRequested == false {
        
        var riderRequest = PFObject(className:"riderRequest")
        
        riderRequest["username"] = PFUser.currentUser()!.username
        
        riderRequest["location"] = PFGeoPoint(latitude:self.lat, longitude:self.long)
        
        
        
        riderRequest.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                
                
                    
                    self.calluberbutton.setTitle("Cancle the Ride", forState: UIControlState.Normal)
                
                
            } else {
                
                let alert = UIAlertController(title:"could not call Uber", message: "please try again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }
        }

       uberRequested = true
        
       } else {
        
        self.calluberbutton.setTitle("Call for uber", forState: UIControlState.Normal)
        
        uberRequested = false
        
        var query = PFQuery(className:"riderRequest")
        query.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil {
                
                
                
              //  print("Successfully retrieved \(objects!) .")
                
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        object.deleteInBackground()
                        
                       // print(object.objectId!)
                    }
                }
               
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
        }
    }
    
        
        
    
    
    
}
