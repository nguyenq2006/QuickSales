//
//  SideMenuController.swift
//  QuickSale
//
//  Created by CS on 12/3/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import Firebase

class BaseViewController: UIViewController {
    
    var isHidden = true
    
    @IBOutlet weak var sideMenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        print("BaseView --- userID: \(AppUser.uId); username \(AppUser.uName); user email: \(AppUser.email)")
        if let nameText = sideMenu.viewWithTag(1) as? UITextField {
            nameText.text = AppUser.uName
            nameText.endEditing(false)
        }
        if let emailText = sideMenu.viewWithTag(2) as? UITextField {
            emailText.adjustsFontSizeToFitWidth = true
            emailText.text = AppUser.email
            emailText.endEditing(false)
        }
        self.sideMenu.alpha = 0
    }
    
    @IBAction func displayInfo(_ sender: Any) {
        if isHidden {
            UIView.animate(withDuration: 0.5, animations: {
                self.sideMenu.alpha = 1
                self.view.alpha = 2
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.sideMenu.alpha = 0
                self.view.alpha = 1
            })
        }
        isHidden = !isHidden
    }
    
    @IBAction func signoutUser(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try? Auth.auth().signOut()
                let loginVC = storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                loginVC.modalTransitionStyle = .crossDissolve
                present(loginVC, animated: true, completion: nil)
            }
        }
    }
    
}
