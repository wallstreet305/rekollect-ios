//
//  address.swift
//  FaceFlip
//
//  Created by Aqib on 14/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import SwiftAddressBook

class address: UITableViewController {
    
    var contacts:[String] = []
    var allContactsArray:NSArray = []
    var selection:Int = 0
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "selectedContact"{
            let vc = segue.destinationViewController as! NewContact
            vc.contactName = contacts[selection]
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func getContactsFromAddressbook()
    {
        
        let status = ABAddressBookGetAuthorizationStatus()
        if status == .Denied || status == .Restricted {
            // user previously denied, to tell them to fix that in settings
            
            print("Access Denied")
            return
        }
        
        var error: Unmanaged<CFError>?
        let addressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue()
        if addressBook == nil {
            print(error?.takeRetainedValue())
            
            print("Error")
            return
        }
        
        
        ABAddressBookRequestAccessWithCompletion(addressBook) {
            granted, error in
            
            if !granted {
                
                
                print("Not Granted")
                return
            }
            
            if let people = ABAddressBookCopyArrayOfAllPeople(addressBook)?.takeRetainedValue() as? NSArray {
                // now do something with the array of people
                
                self.allContactsArray = people
                
                print("All Contacts Array Length: \(self.allContactsArray.count)")
                
                for x in self.allContactsArray{
                    
                    print("------------")
                    print(x)
                    
                    //                    var names:String = ""
                    //                    if (x.firstName != nil)
                    //                    {
                    //                        names += person.firstName!
                    //                    }
                    //                    if (person.lastName != nil)
                    //                    {
                    //                        names += " \(person.lastName!)"
                    //                    }
                    //                    //let names = "\(person.firstName!) \(person.lastName!)"
                    //                    
                    //                    if (names != "")
                    //                    {
                    //                        self.contacts.append(names)
                    //                        
                    //                    }
                    
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    // code here
                    self.tableView.reloadData()
                })
                
                
            }
        }
        
        
    }
    
    func getAllContacts()
    {
        contacts = []
        SwiftAddressBook.requestAccessWithCompletion { (b :Bool, _ :CFError?) -> Void in
            if b {
                if let people : [SwiftAddressBookPerson]? = swiftAddressBook!.allPeople {
                    //access variables on any entry of allPeople array just like always
                    print("People Count: \(people!.count)")
                    for person in people! {
                        
                        
                        
                        // print("name: \(person.firstName) \(person.lastName), number: \(person.phoneNumbers?.map( {$0.value}))")
                        
                        var names:String = ""
                        if (person.firstName != nil)
                        {
                            names += person.firstName!
                        }
                        if (person.lastName != nil)
                        {
                            names += " \(person.lastName!)"
                        }
                        //let names = "\(person.firstName!) \(person.lastName!)"
                        
                        if (names != "")
                        {
                            self.contacts.append(names)
                            
                        }
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        self.tableView.reloadData()
                    })
                    //self.combnineAllContacts()
                    
                }
                
                
                
            }
            
        }
    }
    
    
    
    //    func getAllContacts()
    //    {
    //        
    //        SwiftAddressBook.requestAccessWithCompletion { (b :Bool, _ :CFError?) -> Void in
    //            if b {
    //                if let people : [SwiftAddressBookPerson]? = swiftAddressBook!.allPeople {
    //                                        //access variables on any entry of allPeople array just like always
    //                                        print(people?.count)
    //                                        for person in people! {
    //                                            let names = "\(person.firstName!) \(person.lastName!)"
    //                                            self.contacts.append(names)
    //                    
    //                                        }
    //                                                                self.tableView.reloadData()
    //                                    }
    //                
    //            }
    //        }
    //        
    //        
    ////        SwiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
    ////            if success {
    ////                if let people : [SwiftAddressBookPerson]? = swiftAddressBook!.allPeople {
    ////                    //access variables on any entry of allPeople array just like always
    ////                    print(people?.count)
    ////                    for person in people! {
    ////                        let names = "\(person.firstName!) \(person.lastName!)"
    ////                        self.contacts.append(names)
    ////
    ////                    }
    ////                                            self.tableView.reloadData()
    ////                }
    ////            }
    ////            else {
    ////                //no success. Optionally evaluate error
    ////            }
    ////        })
    //    }
    
    override func viewDidAppear(animated: Bool)
    {
        //        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("contactAdded") {
        //            
        //            let userDefaults = NSUserDefaults.standardUserDefaults()
        //            userDefaults.removeObjectForKey("contactAdded")
        //            userDefaults.synchronize()
        //            self.dismissViewControllerAnimated(true, completion: nil)
        //            
        //        }
        
        //        let userDefaults = NSUserDefaults.standardUserDefaults()
        //        userDefaults.setObject("yes", forKey: "contactAdded")
        //        userDefaults.synchronize()
        
        
        
        //        getContactsFromAddressbook()
        getAllContacts()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //getAllContacts()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        selection = indexPath.row;
        print(selection)
        self.performSegueWithIdentifier("selectedContact", sender: self)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.contacts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        //        cell.textLabel?.text = contacts[indexPath.row]
        cell.textLabel?.text = contacts[indexPath.row] as? String
        
        print(contacts[indexPath.row])
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
