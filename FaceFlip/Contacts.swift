//
//  Contacts.swift
//  FaceFlip
//
//  Created by Aqib on 09/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import GTToast
import Alamofire
import KFSwiftImageLoader


class Contacts: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var allContacts: [contact] = []

    

    var groupID:String = "abc"
    
    @IBOutlet weak var tableView: UITableView!
    
   
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allContacts.count
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("mycell", forIndexPath: indexPath) as! mycellTableViewCell
        
        cell.img.loadImageFromURLString(allContacts[indexPath.row].picture as! String, placeholderImage: UIImage(named: "logo")) {
            (finished, error) in

            // finished is a Bool indicating success or failure.
            // error is an implicitly unwrapped Optional NSError containing the error (if any) when finished is false.
        }
        cell.name.text = self.allContacts[indexPath.row].name

        
        cell.notes.text = "Note : \(self.allContacts[indexPath.row].notes)"
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("contactAdded") {

            self.dismissViewControllerAnimated(true, completion: nil)
            NSUserDefaults.standardUserDefaults().removeObjectForKey("contactAdded")
            
        }
        

    }
    
    func getContactsForGroup(id: String)
    {
        
        allContacts = []
        GTToast.create("Loading contacts. Please wait...").show()
        var apiCall = "https://jasontask.azurewebsites.net/api/index.php?command=loadGroupPeople&group_id="
        apiCall += id
        print(apiCall)
        
        Alamofire.request(.GET, apiCall)
            .responseJSON { response in
                
                let json  = response.result.value as! NSDictionary
                let result = json["result"]! as! [[String : AnyObject]]
                
                if (!result.isEmpty)
                {
                    for r in result {
                        let id = r["contact_id"]! as! String
                        let by = r["added_by"]! as! String
                        let gp = r["group_id"]! as! String
                        let name = r["name"]! as! String
                        let picture = r["picture"]! as! String
                        let added = r["date_added"] as? String
                        let notes = r["notes"] as? String

                        var c:contact!
                        
                        if (notes == nil)
                        {
                            c = contact(id:id, by:by, gp:gp, name:name, picture:picture, added:" ", notes:"none")
                        }
                        else
                        {
                            c = contact(id:id, by:by, gp:gp, name:name, picture:picture, added:" ", notes:notes!)
                        }
                        
                        self.allContacts.append(c)
                        
                    }
                    
                    print(self.allContacts.count)
                    self.tableView.reloadData()
                    //self.performSegueWithIdentifier("joinedGroups", sender: self)
                    
                }
                else
                {
                    GTToast.create("No members in this group.").show()
                }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("currentGpID") {
            self.groupID = id as! String
            
        }
        
        print(self.groupID)
        getContactsForGroup(self.groupID)
        
        
//        scrollView.transition = .None

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    class contact
    {
        
        var contact_id:String!
        var added_by:String!
        var group_id:String!
        var name:String!
        var picture:String!
        var date_added:String!
        var notes:String!
        
        
        
        
        init(id:String, by:String, gp:String, name:String, picture:String, added:String, notes:String)
        {
            self.contact_id = id
            self.added_by = by
            self.group_id = gp
            self.name = name
            self.picture = picture
            self.date_added = added
            self.notes = notes
        }
        
        
    }

}
