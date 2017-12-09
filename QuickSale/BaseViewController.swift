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
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.showSideMenu))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.hideSideMenu))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        print("BaseView --- userID: \(AppUser.uId); username \(AppUser.uName); user email: \(AppUser.email)")
        
        nameText.text = AppUser.uName
        nameText.endEditing(false)
        emailText.adjustsFontSizeToFitWidth = true
        emailText.text = AppUser.email
        
        self.sideMenu.alpha = 0
    }
    
    @IBAction func displayInfo(_ sender: Any) {
        if isHidden {
            showSideMenu()
        }
        else {
            hideSideMenu()
        }
        
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
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                showSideMenu()
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                showSideMenu()
            default:
                break
            }
        }
    }
    
    @objc func showSideMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.sideMenu.alpha = 1
            self.view.alpha = 2
        })
        isHidden = !isHidden
    }
    
    @objc func hideSideMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.sideMenu.alpha = 0
            self.view.alpha = 1
        })
        isHidden = !isHidden
    }
    
}
