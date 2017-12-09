//
//  TableCellViewController.swift
//  QuickSale
//
//  Created by CS on 12/6/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class TableCellView: UITableViewCell {
    var ref = DatabaseReference.init()
    
    
    //table cell view
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtItemName: UILabel!
    @IBOutlet weak var postingImage: UIImageView!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setText(itemData: Any){
        //initialize the text
        if let item = itemData as? SellingItem{
            self.getUserName(uID: item.uId!)
            self.txtItemName.text = item.iName!
            self.txtPrice.text = item.iPrice!
            self.txtDescription.text = item.iDescription!
            self.setPostImage(url: item.imagePath!)
            self.txtDate.text = item.postDate!
        } else if let item = itemData as? NSManagedObject {
            self.getUserName(uID: item.value(forKey: "sellerID") as! String)
            self.txtItemName.text = item.value(forKey: "itemName") as! String
            self.txtPrice.text = item.value(forKey: "itemPrice") as! String
            self.txtDescription.text = item.value(forKey: "itemDescription") as! String
            self.setPostImage(url: item.value(forKey: "imagePath") as! String)
            self.txtDate.text = item.value(forKey: "date") as! String
        }
        
    }
    
    func getUserName(uID: String) {
        var ref = Database.database().reference()
        ref.child("users").child(uID).observe(.value, with: {
            (snapshot) in
            
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot{
                    
                    if let postKey = snap.key as? String{
                        
                        if postKey == "name" {
                            if let fullName = snap.value as? String{
                                self.txtUserName.text = fullName
                            }
                        }
                    }
                }
                
            }
            
        })
    }
    
    func setPostImage(url:String){
        let storageRef = Storage.storage().reference(forURL: "gs://quicksale-970e1.appspot.com/")
        let postImageRef = storageRef.child(url)
        postImageRef.getData(maxSize: 8 * 1024 * 1024, completion: {(data, error) in
            
            if let error = error{
                print("cannot load image")
            }else{
                self.postingImage.image = UIImage(data:data!)
            }
            
        })
    }
    
    
}
