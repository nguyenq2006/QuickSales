//
//  ListingViewController.swift
//  QuickSale
//
//  Created by CS on 12/6/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreData

class ListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    
    var listOfPosts = [SellingItem]()
    var ref = Database.database().reference(fromURL: "https://quicksale-970e1.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.dataSource = self
        listView.delegate = self
        loadPostFromFirebase()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPosts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = listOfPosts[indexPath.row]
        let postView = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TableCellView
        postView.setText(itemData: post)
        
        //adding map marker
        let lat = Double(post.iLat!)
        let long = Double(post.iLong!)
        
        let marker = MKPointAnnotation()
        marker.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        marker.title = post.iName
        marker.subtitle = post.iPrice
        MapViewController.markers.append(marker)
        
        return postView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.bookmarkPost(sender:))))
    }
    
    @objc func bookmarkPost(sender: UITapGestureRecognizer){
        //using sender, we can get the point in respect to the table view
        let tapLocation = sender.location(in: self.listView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.listView.indexPathForRow(at: tapLocation)
        
        let index = indexPath?.row
        let item = listOfPosts[index!]
        
        print("Saving post to Core Data")
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        do {
            //avoid duplicate in core data
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "BookmarkPost")
            let predicate = NSPredicate(format: "postID = %@", item.postID!)
            fetchRequest.predicate = predicate
            let fetchResult = try managedContext.fetch(fetchRequest)
            if(fetchResult.count <= 0) {
                let entity =
                    NSEntityDescription.entity(forEntityName: "BookmarkPost",
                                               in: managedContext)!
                
                let post = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
                post.setValue(item.iName, forKey:"itemName")
                post.setValue(item.iPrice, forKey: "itemPrice")
                post.setValue(item.iDescription, forKey: "itemDescription")
                post.setValue(item.uId, forKey: "sellerID")
                post.setValue(item.imagePath, forKey: "imagePath")
                post.setValue(item.postDate, forKey: "date")
                post.setValue(item.postID, forKey: "postID")
                
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 500
//        }
    
    func loadPostFromFirebase(){
        self.ref.child("Posts").queryOrdered(byChild: "date").observe(.value, with: {
            (snapshot) in
            self.listOfPosts.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot{
                    if let postDic = snap.value as? [String:Any]{
                        var postID = snap.key
                        var userUID:String?
                        if let userUIDF = postDic["uID"] as? String {
                            userUID = userUIDF
                        }
                        var itemName:String?
                        if let iName = postDic["itemName"] as? String{
                            itemName = iName
                        }
                        var itemPrice:String?
                        if let iPrice = postDic["itemPrice"] as? String{
                            itemPrice = iPrice
                        }
                        var itemDescription:String?
                        if let iDescription = postDic["itemDescription"] as? String{
                            itemDescription = iDescription
                        }
                        var postDate:CLong?
                        if let postDateF = postDic["date"] as? CLong {
                            postDate = postDateF
                        }
                        let date = postDate!.getDateStringFromUTC()
                        var postImage:String?
                        if let postImageF = postDic["itemImage"] as? String {
                            postImage = postImageF
                        }
                        
                        print("\(postDic["itemLat"]), \(postDic["itemLong"])")
                        
                        var itemLat:String!
                        if let iLat = postDic["itemLat"] as? Double {
                            itemLat = (iLat as NSNumber).stringValue
                        }
                        var itemLong:String!
                        if let iLong = postDic["itemLong"] as? Double {
                            itemLong = (iLong as NSNumber).stringValue
                        }
                        let item = SellingItem(postID: postID, uId: userUID!
                            , iName: itemName!, iPrice: itemPrice!, iDescription: itemDescription!, imagePath: postImage!, postDate: "\(date)", iLat: itemLat!, iLong: itemLong!)
                        self.listOfPosts.append(item)
                        
                    }
                }
                self.listView.reloadData()
            }
        })
    }
    
}

//convert CLong to date
extension CLong {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_DD_yy_h_mm"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}



