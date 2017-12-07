//
//  UserData.swift
//  QuickSale
//
//  Created by CS on 12/3/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

struct AppUser {
    static var uId:String?
    static var uName:String?
    static var email:String?
    
    init(uId: String, uName: String, email: String) {
        AppUser.uId = uId
        AppUser.uName = uName
        AppUser.email = email
    }
}

class SellingItem {
    var uId:String?
    var iName:String?
    var iPrice:String?
    var iDescription: String?
    var imagePath: String?
    var postDate: String?
    var iLat:String?
    var iLong:String?
    
    init(uId: String, iName: String, iPrice: String, iDescription: String,
         imagePath: String, postDate: String, iLat: String, iLong: String) {
        self.uId = uId
        self.iName = iName
        self.iPrice = iPrice
        self.iDescription = iDescription
        self.imagePath = imagePath
        self.postDate = postDate
        self.iLat = iLat
        self.iLong = iLong
    }
}
