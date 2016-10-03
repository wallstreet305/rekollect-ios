//
//  Home.swift
//  FaceFlip
//
//  Created by Aqib on 08/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import KFSwiftImageLoader
import Alamofire
import GTToast

class Home: UIViewController {
    
   
    @IBOutlet weak var myGp: UIImageView!
    @IBOutlet weak var create: UIImageView!
    @IBOutlet weak var join: UIImageView!
    
    @IBOutlet weak var joinedGp: UILabel!
    var username:String!
    var id:String!
    var picUrl:String!

    var allGroups: [group] = []
    
    @IBOutlet weak var joinedGroups: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBAction func joinGroupButtonDown(sender: UIButton) {
        
        let alert = UIAlertController(title: "Join Group", message: "Enter Provided Group Code", preferredStyle: UIAlertControllerStyle.Alert)
        
        let nameBody = UITextField();
        
        let okAction = UIAlertAction(title: "Join", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            NSLog("OK Pressed")
            print((alert.textFields!.first! as UITextField).text)
            
            let secretCode = (alert.textFields!.first! as UITextField).text
            
            self.joinGroup(self.id, secretCode: secretCode! as String)
            
        }
        
        
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            
            UIAlertAction in
            NSLog("back Pressed")
            
            
        }
        
        
        
        alert.addAction(okAction)
        alert.addAction(cancel)
        alert.addTextFieldWithConfigurationHandler({ nameBodty in  nameBody.placeholder = "Group Name"})
        
        self.presentViewController(alert, animated: true, completion: nil)
        

        
    }
    
    @IBAction func myGroupsButtonDown(sender: UIButton) {
        
        self.performSegueWithIdentifier("joinedGroups", sender: self)
       // self.getJoinedGroups(self.id)
    }

    @IBAction func createGroupButtonDown(sender: UIButton) {
    
        let alert = UIAlertController(title: "Create Group", message: "Enter Your Desired Group Name", preferredStyle: UIAlertControllerStyle.Alert)
        
        let nameBody = UITextField();
        
        let okAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default) {
            
            
                UIAlertAction in
                NSLog("OK Pressed")
                print((alert.textFields!.first! as UITextField).text)
            
                let groupName = (alert.textFields!.first! as UITextField).text
                
                let secretCode = self.randomStringWithLength(6)
            if (groupName != "")
            {
                self.createGroup(self.id, name: groupName!, secretCode: secretCode as String)
            }
            else
            {
                print("Enter name first")
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            
            UIAlertAction in
            NSLog("back Pressed")
            
            
        }

        alert.addAction(okAction)
        alert.addAction(cancel)
        
        
        alert.addTextFieldWithConfigurationHandler({ nameBodty in  nameBody.placeholder = "Group Name"})
        
        self.presentViewController(alert, animated: true, completion: nil)

        
    }
    
    
    func getJoinedGroups(id: String)
    {
        allGroups = []
        GTToast.create("Loading groups. Please wait...").show()
        var apiCall = "https://jasontask.azurewebsites.net/api/index.php?command=joinedGroup&user_id="
        apiCall += id

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
                    

                }
                else
                {
                   GTToast.create("You haven't joined any group").show()
                }
        }

        
        
    
    }
    
    func joinGroup(id: String, secretCode: String)
    {
        
         GTToast.create("Sending Request. Please wait...").show()
        
        var apiCall = "https://jasontask.azurewebsites.net/api/index.php?command=joinGroup&id="
        apiCall += id
        apiCall += "&group_code="
        apiCall += secretCode
        
        
        apiCall = apiCall.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        print(apiCall)
        
        Alamofire.request(.GET, apiCall)
            .responseString { response in
                if (response.result.value != nil)
                {
                    print("Response String: \(response.result.value)")
                    GTToast.create(response.result.value!).show()
                }
        }
        

        
    }
    
    func createGroup(id: String, name: String, secretCode: String)
    {
        
            GTToast.create("Creating Group. Please wait...").show()
        var apiCall = "https://jasontask.azurewebsites.net/api/index.php?command=createGroup&own="
        apiCall += id
        apiCall += "&name="
        apiCall += name
        apiCall += "&code="
        apiCall += secretCode
        apiCall += "&members=0"
        
        
        apiCall = apiCall.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        print(apiCall)
        
        
        Alamofire.request(.GET, apiCall)
            .responseString { response in
                if (response.result.value != nil)
                {
                        print("Response String: \(response.result.value)")
                        GTToast.create(response.result.value!).show()
                }
            }
        
        
        
        
    }
    
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        //self.navigationController?.popViewControllerAnimated(true)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject("yes", forKey: "logout")
        userDefaults.synchronize()
        
        print("Button tapped")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func buttonAction(sender:UIButton!)
    {
        print("Button tapped")
    }
    
    func createGp(img: AnyObject)
    {
        print("YESS")
        createGroupButtonDown(UIButton())
    }
    
    
    func joinGp(img: AnyObject)
    {

                print("YESS")
        joinGroupButtonDown(UIButton())
    }
    
    
    func myGps(img: AnyObject)
    {
                print("YESS")
        myGroupsButtonDown(UIButton())
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.joinedGp.font = UIFont(name: "Bellerose.ttf", size: 25)
        
        
        let tapGestureCreate = UITapGestureRecognizer(target:self, action:Selector("createGp:"))
        
        let tapGestureJoin = UITapGestureRecognizer(target:self, action:Selector("joinGp:"))
        
        let tapGestureMy = UITapGestureRecognizer(target:self, action:Selector("myGps:"))
        
        
        myGp.addGestureRecognizer(tapGestureMy)
        create.addGestureRecognizer(tapGestureCreate)
        join.addGestureRecognizer(tapGestureJoin)
        
        self.title = "Recollekt"
        
        var logButton : UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        
        logButton.tintColor = UIColor.whiteColor()

        self.navigationItem.leftBarButtonItem = logButton
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            self.id = id as! String
            
        }
        
        
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("username") {
            self.username = username as! String
            self.helloLabel.text = "\(self.username)"
        }
        
        
        if let url: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("url") {
            

            userImage.loadImageFromURLString(url as! String, placeholderImage: UIImage(named: "loading")) {
                (finished, error) in
                
                // finished is a Bool indicating success or failure.
                // error is an implicitly unwrapped Optional NSError containing the error (if any) when finished is false.
            }

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
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
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
