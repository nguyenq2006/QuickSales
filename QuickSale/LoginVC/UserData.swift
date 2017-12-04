//
//  UserData.swift
//  QuickSale
//
//  Created by CS on 12/3/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

class UserData: NSObject {
    struct User {
        var uId:String?
        var uName:String?
        var email:String?
        
        init(uId: String, uName: String, email: String) {
            self.uId = uId
            self.uName = uName
            self.email = email
        }
        
        init() {
        }
    }
}
