//
//  ListTableViewController.swift
//  ParqueoApp
//
//  Created by internet on 5/13/15.
//  Copyright (c) 2015 internet. All rights reserved.
//

import UIKit
import CoreData
class ListTableViewController: UITableViewController {
    
    var myList:Array<AnyObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Load....")
        var id = UIDevice.currentDevice().identifierForVendor.UUIDString
        println(id)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        println("Load....Parkings list")
        // Dispose of any resources that can be recreated.
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest (entityName: "Parking")
        
        myList = context.executeFetchRequest(freq, error: nil)!
        println("Load....Table")
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Variable..")
        if (segue.identifier == "update")
        {   println("NEXT...")
            var seletedIndex = self.tableView.indexPathForSelectedRow()?.row
            var selectedItem: NSManagedObject = myList[seletedIndex!] as NSManagedObject
            let desti = segue.destinationViewController as ItemViewController
            desti.currentItem = selectedItem
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellID: NSString = "Cell"
        //var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell
        //cell.textLabel!.text = "test"
        
        var data:NSManagedObject = myList[indexPath.row] as NSManagedObject
        
        var titleCell = data.valueForKey("address") as? String
        var subtitleCell = data.valueForKey("schedule") as? String
        var rateCell = data.valueForKey("rate") as? String
        
        cell.textLabel?.text = titleCell
        
        
        cell.detailTextLabel?.text="Hrs: " + subtitleCell! + "  Rate: " + rateCell! + " Bs." 
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt:NSManagedObjectContext = appDel.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            var deletedItem:NSManagedObject = myList[indexPath.row] as NSManagedObject
            contxt.deleteObject(deletedItem)
            myList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        }
        
        contxt.save(nil);
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

