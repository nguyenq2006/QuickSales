//
//  AppDelegate.swift
//  QuickSale
//
//  Created by CS on 11/30/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //initialize Google sso
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Failed to log into Google  ")
            print("\(error.localizedDescription)")
            
        } else {
            
            //authenticate user with token
            guard let idToken = user.authentication.idToken else {return}// Safe to send to the server
            guard let accessToken = user.authentication.accessToken else {return}
            
            //create google credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // retrieve infomation on signed in user
            let fullName = user.profile.name
            let email = user.profile.email
            
            Auth.auth().signIn(with: credential, completion: {(user, error) in
                if error != nil{
                    print("failed to authenticate user with google")
                    return
                }
                print("login successfule with user: \(user?.displayName)")
                
                let ref = Database.database().reference(fromURL: "https://quicksale-970e1.firebaseio.com/")
                guard let uId = user?.uid else{return}
                let userReference = ref.child("users").child(uId)
                let value = ["name": fullName, "email": email]
                userReference.updateChildValues(value, withCompletionBlock: {(error, ref) in
                    if error != nil {
                        print("User \(uId) cannot be updated")
                        return
                    }
                    
                    print("Saved user successful in Firebase")
                })
            })
        }
    }
    
    func application(application: UIApplication,
                     openURL url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
