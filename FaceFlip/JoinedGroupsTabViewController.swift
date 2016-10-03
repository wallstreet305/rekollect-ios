//
//  JoinedGroupsTabViewController.swift
//  FaceFlip
//
//  Created by Aqib on 08/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import GTToast
import Alamofire

class JoinedGroupsTabViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topRated: UITabBarItem!
    
var selection:Int = 0
    @IBOutlet weak var tableView: UITableView!
    var allGroups: [group] = []
    var id:String!
    
    
    
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.allGroups.count

    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("gpCell", forIndexPath: indexPath) as! groupCell
        
                cell.name.text = self.allGroups[indexPath.row].group_name
                return cell
    }
    

  
    

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Table view data source
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        //print(allGroups.count)
//        return self.allGroups.count
//    }
//    
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("gpCell", forIndexPath: indexPath) as! groupCell
//        
//        cell.name.text = self.allGroups[indexPath.row].group_name
//        return cell
//    }

    
    
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        selection = indexPath.row;
        print(selection)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.allGroups[indexPath.row].group_id, forKey: "currentGpID")
        userDefaults.synchronize()
        self.performSegueWithIdentifier("joingp", sender: self)
    }

    
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
