//
//  MyGroupsViewController.swift
//  FaceFlip
//
//  Created by Aqib on 08/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import GTToast
import Alamofire

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class MyGroupsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var urlShare:String = "http://bit.ly/1234"
    
    @IBOutlet weak var myGpsBtn: UITabBarItem!
    var selection:Int = 0
    @IBOutlet weak var tableView: UITableView!
    var allGroups: [group] = []
    var id:String!
    
    @IBAction func btnShare(sender: UIButton) {
        
        print("Share")
        let textToShare = "You can join my RECOLLEKT group by entering the following code: \(id). If you don't yet have the app, get it here: \(urlShare)"
        //"Hello. This is the Group code for my Recollekt Group: \(id) Please add it with yourself"
        
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        selection = indexPath.row;
        print(selection)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.allGroups[indexPath.row].group_id, forKey: "currentGpID")
        userDefaults.synchronize()
        self.performSegueWithIdentifier("mygpdetail", sender: self)
    }
    
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
        cell.gpCode.text = "Group Code: \(self.allGroups[indexPath.row].group_code)"
        
        cell.shareButton.addTarget(self, action: "shareButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.deleteButton.addTarget(self, action: "deleteButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.shareButton.tag = indexPath.row
        
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
    
    
    func deleteButtonAction(sender:UIButton!)
    {
        
        let alert = UIAlertView()
        alert.message = "Haseeb hasn't made any delete request yet."
        alert.title = "Coming soon..."
        alert.addButtonWithTitle("OKkay")
        alert.show()
        
        //        var num:Int = sender.tag as! Int
        //        print("Button tapped\(sender.tag)")
        //        let textToShare = "You can join my RECOLLEKT group by entering the following code: \(self.allGroups[num].group_code). If you don't yet have the app, get it here: \(urlShare)"
        //        
        //        
        //        let objectsToShare = [textToShare]
        //        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //        
        //        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    func shareButtonAction(sender:UIButton!)
    {
        var num:Int = sender.tag as! Int
        print("Button tapped\(sender.tag)")
        let textToShare = "You can join my RECOLLEKT group by entering the following code: \(self.allGroups[num].group_code). If you don't yet have the app, get it here: \(urlShare)"
        
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        
        self.tableView.tintColor = UIColor(netHex: 0x2e354f)
        
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
    
    func getAllGroups(id: String)
    {
        allGroups = []
        GTToast.create("Loading groups. Please wait...").show()
        var apiCall = "http://jasontask.azurewebsites.net/api/index.php?command=loadMyGroup&registar_id="
        apiCall += id
        
        print(apiCall)
        
        print(apiCall)
        
        Alamofire.request(.GET, apiCall)
            .responseJSON { response in
                
                let json  = response.result.value as! NSDictionary
                let result = json["result"]! as! [[String : AnyObject]]
                
                if (!result.isEmpty)
                {
                    for r in result {
                        let group_id = r["group_id"]! as! String
                        let created_by = r["created_by"]! as! String
                        let group_name = r["group_name"]! as! String
                        let group_code = r["group_code"]! as! String
                        let members_count = r["members_count"]! as! String
                        let date_created = " "//r["date_created"]! as! String
                        let join_id = " "//r["join_id"]! as! String
                        
                        
                        let gp = group(id: group_id, by: created_by, name: group_name, code:group_code, count:members_count, created:date_created, joined:join_id )
                        
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
        var created_by:String!
        var group_name:String!
        var group_code:String!
        var members_count:String!
        var date_created:String!
        var join_id:String!
        
        
        init(id: String, by: String, name: String, code:String, count:String, created:String, joined:String )
        {
            self.group_id = id
            self.created_by = by;
            self.group_name = name
            self.group_code = code
            self.members_count = count
            self.date_created = created
            self.join_id = joined
        }
        
        
    }
    
}
