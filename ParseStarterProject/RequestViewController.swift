//
//  RequestViewController.swift
//  Uber_yesh
//
//  Created by Yeswanth varma Kanumuri on 1/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse
import CoreLocation

class RequestViewController: UIViewController ,CLLocationManagerDelegate {
    
    @IBOutlet weak var userLocationMap: MKMapView!
      @IBOutlet weak var Buttonpressed: UIButton!
    
    @IBOutlet weak var reuestedUsernameLbl: UILabel!
    
    @IBOutlet weak var reuesteduserContact: UILabel!
    
    var requestLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var requestUsername :String = "yesh"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.reuestedUsernameLbl.text = "Requested User : " + requestUsername
        
        self.reuesteduserContact.text = " Contact no: +1 (813) 331-9456 "

       print(requestUsername)
        print(requestLocation)
        
 
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.userLocationMap.setRegion(region, animated: true)
        
        
        
        
        
        var objectAnnotation = MKPointAnnotation()
        
        objectAnnotation.coordinate = requestLocation
        
        objectAnnotation.title = "Rider position"
        
        self.userLocationMap.addAnnotation(objectAnnotation)

        
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
    
    @IBAction func buttonpressed(sender: AnyObject) {
        
        
        var query = PFQuery(className:"riderRequest")
        query.whereKey("username", equalTo:requestUsername)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil {
                
                
                
                //  print("Successfully retrieved \(objects!) .")
                
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        
                        var query = PFQuery(className: "riderRequest")
                        
                        query.getObjectInBackgroundWithId(object.objectId!!) { (object, error) -> Void in
                            
                            if error != nil {
                            
                            print(error)
                            
                            } else {
                            
                            
                            object!["driverResponded"] = PFUser.currentUser()!.username!
                                
                                object!.saveInBackground()
                                
                                 let requestCLLocation = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
                                
                                CLGeocoder().reverseGeocodeLocation(requestCLLocation, completionHandler: {(placemarks, error)-> Void in
                                    
                                    if (error != nil) {
                                        print("Reverse geocoder failed with error" + error!.localizedDescription)
                                        
                                    } else {
                                    
                                    if placemarks!.count > 0 {
                                        let pm = placemarks![0] as! CLPlacemark
                                        
                                        let mkPm = MKPlacemark(placemark: pm)
                                        
                                        
                                        var mapItem = MKMapItem(placemark:mkPm)
                                        
                                        mapItem.name = self.requestUsername
                                        
                                        //You could also choose: MKLaunchOptionsDirectionsModeWalking
                                        var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                        
                                        mapItem.openInMapsWithLaunchOptions(launchOptions)
                                        
                                    } else {
                                        print("Problem with the data received from geocoder")
                                    }
                                    }
                                })
                                
                             
                            
                            }
                            
                            
                            
                        }
                        
                        
                        
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
