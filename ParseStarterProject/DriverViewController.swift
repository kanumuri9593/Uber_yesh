//
//  DriverViewController.swift
//  Uber_yesh
//
//  Created by Yeswanth varma Kanumuri on 1/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class DriverViewController: UITableViewController ,CLLocationManagerDelegate ,MKMapViewDelegate {
    
    var locationManager:CLLocationManager!
    
    var lat :CLLocationDegrees = 0
    var long :CLLocationDegrees = 0

    var distancs = [CLLocationDistance]()
    var usernames = [String]()
    var locations = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()


    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        var location:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.lat = location.latitude
        self.long = location.longitude
        
       // print("Locations : \(lat) , \(long)")
        var query = PFQuery(className:"riderRequest")
        
        query.whereKey("location", nearGeoPoint:PFGeoPoint(latitude:location.latitude, longitude:location.longitude))
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil {
                
                
                
                //print("Successfully retrieved \(objects!) .")
                
                // Do something with the found objects
                if let objects = objects {
                    
                    self.usernames.removeAll()
                    self.locations.removeAll()
                    
                    
                    for object in objects {
                        
                        if let object:PFObject = object as! PFObject{
                        
                        
                        print(object["driverResponded"])
                        
                        
                       if object["driverResponded"] == nil {
                        
                        if let username = object["username"] as? String {
                            
                            self.usernames.append(username)
                            
                        }
                        
                        if let returnedLocation = object["location"] as? PFGeoPoint {
                            
                            let requestLocation =  CLLocationCoordinate2DMake(returnedLocation.latitude, returnedLocation.longitude)
                            
                            self.locations.append(requestLocation)
                            
                        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
                            
                         let driverCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                            
                          let distnace = driverCLLocation.distanceFromLocation(requestCLLocation)
                            
                            self.distancs.append(distnace/1000)
                            
                            
                            }
                        }
                    }
                    }
                    
                        self.tableView.reloadData()
                       // print(self.locations)
                      //  print(self.usernames)
                        
                    
                }
                
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        var distanceDouble = Double( distancs[indexPath.row])
        
        var roundedDistance = Double(round(distanceDouble * 10) / 10)

       cell.textLabel?.text = usernames[indexPath.row] + " - " + String(roundedDistance) + "Km away."
        

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "logoutDriver" {
            
            navigationController?.setNavigationBarHidden(true, animated: false)
            
            PFUser.logOut()
            
            
        } else if segue.identifier == "showViewRequests" {
        
        let destination = segue.destinationViewController as? RequestViewController
        
        destination?.requestLocation = locations[(tableView.indexPathForSelectedRow?.row)!]
            destination?.requestUsername = usernames[(tableView.indexPathForSelectedRow?.row)!]
            
        }
    }

}
