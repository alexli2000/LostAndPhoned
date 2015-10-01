//
//  HomeViewController.swift
//  LostAndPhoned
//
//  Created by Alexander Li on 2015-09-27.
//  Copyright © 2015 Alexander Li. All rights reserved.
//

let phoneNumber = "1-848-999-3399"

import UIKit

var locationManager:CLLocationManager?

class HomeViewController: UIViewController {

    @IBOutlet weak var lastRetrievedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        
        checkForLocation()
    }

    func checkForLocation() {
        if PFUser.currentUser() == nil {
            return
        }
        
        PFUser.currentUser()!.fetchInBackgroundWithBlock({ (object, error) -> Void in
            if PFUser.currentUser()!["location"] != nil {
                let location = (PFUser.currentUser()!["location"] as! PFGeoPoint)
                
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: { (placemarks, error) -> Void in
                    if error == nil && placemarks != nil {                        self.lastRetrievedLabel.text = "Last located on \(self.formatDate(PFUser.currentUser()!.updatedAt!)) at \(self.formatLocation(placemarks![0])))"
                    }
                    
                })

                
            } else {
                self.lastRetrievedLabel.text = "You have not tried searching for this phone yet. \n To test it out, please call this toll- free number \(phoneNumber)"
                
            }
        })
    }
    
    @IBAction func testPhoneNumberButtonTapped(sender: AnyObject) {
        //TODO- Add phone number to contact
    }
    
    func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    func formatLocation(placemark:CLPlacemark) -> String {
        
            var locationString = ""
            if placemark.name != nil {
                locationString += placemark.name! + ", "
            }
            
            if placemark.locality != nil {
                locationString += placemark.locality! + ", "
            }
            
            if placemark.administrativeArea != nil {
                locationString += placemark.administrativeArea!
            }
            return locationString
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
