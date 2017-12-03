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

class ViewController: UIViewController, GIDSignInUIDelegate{
    
    @IBOutlet weak var viewContainer: UIView!
    var registerView: [(UIView)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        registerView = [UIView]()
        registerView.append(LoginView().view)
        registerView.append(SignupView().view)

        for view in registerView{
            viewContainer.addSubview(view)
        }
        
        //add google sign in button on login layout
        let googleBttn = GIDSignInButton()
        googleBttn.frame = CGRect(x: 93, y: 114+50, width: 138, height: 50)
        registerView[0].addSubview(googleBttn)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        viewContainer.bringSubview(toFront: registerView[0])
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
                return
            }
            print("login successful")
        })
    }
}

