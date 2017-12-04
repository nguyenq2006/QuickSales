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
    
    var user = LoginViewController.user
    
    var isHidden = true
    
    @IBOutlet weak var sideMenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("BaseView --- userID: \(user.uId); username \(user.uName); user email: \(user.email)")
        if let nameText = sideMenu.viewWithTag(1) as? UITextField {
            nameText.text = user.uName
        }
        if let emailText = sideMenu.viewWithTag(2) as? UITextField {
            emailText.adjustsFontSizeToFitWidth = true
            emailText.minimumFontSize = 10.0
            emailText.text = user.email
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
        
        do {
            try? Auth.auth().signOut()
            
            if Auth.auth().currentUser == nil {
                self.navigationController?.navigationBar.isHidden = true
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
            
        }
    }
    
}
