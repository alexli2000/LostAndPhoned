//
//  AppDelegate.swift
//  LostAndPhoned
//
//  Created by Alexander Li on 2015-09-26.
//  Copyright © 2015 Alexander Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        Parse.setApplicationId("5UzhftFuo2pTlYtgrNGQodwJXDNwBEvZdGiYI1PL",
            clientKey: "APEdc8qSyoa2I6ojS3PG772RbQqm5xjHDbAbMUvT")
        
        application.applicationIconBadgeNumber = 0

        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        application.registerForRemoteNotifications()
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    //FIXME- Only processes push correctly when app is in background. If manually terminated, it does not process UNTIL opened
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(UIBackgroundFetchResult.NewData)
                if PFUser.currentUser() != nil {
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (userLocation, error) -> Void in
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(CLLocation(latitude: userLocation!.latitude, longitude: userLocation!.longitude), completionHandler: { (placemarks, error) -> Void in
                    if error == nil && placemarks != nil {
                        print("3")
                        PFUser.currentUser()!["location"] = userLocation
                        PFUser.currentUser()!["locationString"] = self.formatPlacemark(placemarks![0])
                            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success, error) -> Void in
                                print(success)
                            })
                    }
                    
                })
                
                
            })
        } else {
    print("Could not respond to push because the user is not online")
    }
    
    if application.applicationState == UIApplicationState.Inactive {
    PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    }
}
    
    func formatPlacemark(placemark:CLPlacemark) -> String {
        
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

func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


}

