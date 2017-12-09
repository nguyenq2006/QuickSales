//
//  BookmarkListTableViewController.swift
//  QuickSale
//
//  Created by CS on 12/8/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import CoreData

class BookmarkListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var bookmarks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BookmarkPost")
        
        do {
            bookmarks = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count;
    }

 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = bookmarks[indexPath.row]
        let postView = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TableCellView
        postView.setText(itemData: post)
    
        return postView
    }
 
    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
//     Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //delete data from core data
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            context.delete(bookmarks[indexPath.row] as NSManagedObject)
            bookmarks.remove(at: indexPath.row)
            
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
//          Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }  
    }




}
