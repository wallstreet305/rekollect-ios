//
//  JoinedGroups.swift
//  FaceFlip
//
//  Created by Aqib on 08/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import GTToast
import Alamofire


class JoinedGroups: UITableViewController {

    var allGroups: [group] = []
    var id:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            self.id = id as! String
            getAllGroups(self.id)
            
        }
        else
        {
            print("not set")
        }

        
       
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(allGroups.count)
        return self.allGroups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("gpCell", forIndexPath: indexPath) as! groupCell

        cell.name.text = self.allGroups[indexPath.row].group_name
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
    
    func getAllGroups(id: String)
    {
        allGroups = []
        GTToast.create("Loading groups. Please wait...").show()
        var apiCall = "https://jasontask.azurewebsites.net/api/index.php?command=joinedGroup&user_id="
        apiCall += id

        print(apiCall)
        
        Alamofire.request(.GET, apiCall)
            .responseJSON { response in
                
                let json  = response.result.value as! NSDictionary
                let result = json["result"]! as! [[String : AnyObject]]
                
                if (!result.isEmpty)
                {
                    for r in result {
                        let id = r["group_id"]! as! String
                        let name = r["group_name"]! as! String
                        let code = r["group_code"] as! String
                        let user = r["user_id"] as! String
                        let count = r["members_count"] as! String
                        
                        let gp = group(id: id, name: name, code:code, user:user, count:count)
                        
                        self.allGroups.append(gp)
                        
                    }
                    
                    print(self.allGroups.count)
                    self.tableView.reloadData()
                    //self.performSegueWithIdentifier("joinedGroups", sender: self)
                    
                }
                else
                {
                    GTToast.create("You haven't joined any group").show()
                }
        }

        
    }
    
    func getJoinedGroups(id: String)
    {
        allGroups = []
        GTToast.create("Loading groups. Please wait...").show()
        var apiCall = "https://jasontask.azurewebsites.net/api/index.php?command=joinedGroup&user_id="
        apiCall += id
        
        print(apiCall)
        
        Alamofire.request(.GET, apiCall)
            .responseJSON { response in
                
                let json  = response.result.value as! NSDictionary
                let result = json["result"]! as! [[String : AnyObject]]
                
                if (!result.isEmpty)
                {
                    for r in result {
                        let id = r["group_id"]! as! String
                        let name = r["group_name"]! as! String
                        let code = r["group_code"] as! String
                        let user = r["user_id"] as! String
                        let count = r["members_count"] as! String
                        
                        let gp = group(id: id, name: name, code:code, user:user, count:count)
                        
                        self.allGroups.append(gp)
                        
                    }
                    
                    print(self.allGroups.count)
                    self.performSegueWithIdentifier("joinedGroups", sender: self)
                    
                }
                else
                {
                    GTToast.create("You haven't joined any group").show()
                }
        }
        
        
        
        
    }
    
    class group
    {
        
        var group_id:String!
        var group_name:String!
        var group_code:String!
        var user_id:String!
        var members_count:String!
        
        
        init(id: String, name: String, code:String, user:String, count:String)
        {
            self.group_id = id
            self.group_name = name
            self.group_code = code
            self.user_id = user
            self.members_count = count
            
        }
        
        
    }

}
