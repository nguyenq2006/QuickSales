//
//  ViewController.swift
//  QuickSale
//
//  Created by CS on 11/30/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    @IBOutlet weak var viewContainer: UIView!
    var registerView: [(UIView)] = []
    static var user:UserData.User = UserData.User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerView = [UIView!]()
        registerView.append(LoginView().view)
        registerView.append(SignupView().view)
        
        for view in registerView{
            viewContainer.addSubview(view)
        }
        
        if let userID = Auth.auth().currentUser?.uid{
            self.goToHomePage()
        }else {
            
            //add google sign in button on login layout
            let googleBttn = GIDSignInButton()
            googleBttn.frame = CGRect(x: 93, y: 114+50, width: 138, height: 50)
            registerView[0].addSubview(googleBttn)
            
            //adding the delegates
            GIDSignIn.sharedInstance().uiDelegate = self as GIDSignInUIDelegate
            GIDSignIn.sharedInstance().delegate = self
            viewContainer.bringSubview(toFront: registerView[0])
        }
        
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
                self.goToHomePage()
            })
        }
    }
    
    @IBAction func switchLoginSegment(_ sender: UISegmentedControl) {
        let selection = sender.selectedSegmentIndex
        viewContainer.bringSubview(toFront: registerView[selection])
    }
    
    @IBAction func signupAction(_ sender: Any) {
        print("signing up user")
        var password:String?
        var email:String?
        var name:String?
        //signup form
        if let signupNameFeild = registerView[1].viewWithTag(1) as? UITextField {
            name = signupNameFeild.text!
            print(name!)
        }
        
        if let signupEmailFeild = registerView[1].viewWithTag(2) as? UITextField {
            email = signupEmailFeild.text!
            print(email!)
        }
        
        if let signupPasswordFeild = registerView[1].viewWithTag(3) as? UITextField {
            password = signupPasswordFeild.text!
            print(password!)
        }
        
        
        Auth.auth().createUser(withEmail: email!, password: password!, completion: {(user: User?, error) in
            if error != nil {
                print(error)
                return
            }
            
            print("authenticate user successfull")
            let ref = Database.database().reference(fromURL: "https://quicksale-970e1.firebaseio.com/")
            
            guard let uId = user?.uid else{return}
            let userReference = ref.child("users").child(uId)
            let value = ["name": name, "email": email]
            userReference.updateChildValues(value, withCompletionBlock: {(error, ref) in
                if error != nil {
                    print("User \(uId) cannot be updated")
                    return
                }
                self.goToHomePage()
                print("Saved user successful in Firebase")
            })
            
        })
    }
    
    @IBAction func loginAction(_ sender: Any) {
        print("log in action")
        var email:String?
        var password:String?
        
        if let loginEmailFeild = registerView[0].viewWithTag(1) as? UITextField {
            email = loginEmailFeild.text!
            print(email!)
        }
        
        if let loginPasswordFeild = registerView[0].viewWithTag(2) as? UITextField {
            password = loginPasswordFeild.text!
            print(password!)
        }
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: {(user, error) in
            if error != nil{
                print(error)
            }else{
                print("login successful")
                self.goToHomePage()
            }
        })
        
        
    }
    
    func goToHomePage(){
        print("starting home page view")
        
        let dbRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        dbRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            print("userID: \(userID); username: \(username); user email: \(email)")
            
            LoginViewController.user = UserData.User(uId: userID!, uName: username, email: email)
            self.performSegue(withIdentifier: "HomePage", sender: nil)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "HomePage"{
    //
    //            if let homePage = segue.destination as? BaseViewController{
    //                if let userInfo = sender as? UserData.User{
    //                    homePage.uId = userInfo.uId
    //                    homePage.uName = userInfo.uName
    //                    homePage.email = userInfo.email
    //                }
    //            } else {
    //                print(segue)
    //            }
    //        }
    //    }
    
    
}

