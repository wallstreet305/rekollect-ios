//
//  ViewController.swift
//  FaceFlip
//
//  Created by Aqib on 08/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import GTToast
import SwiftyJSON
import SwiftAddressBook
import TwitterKit
import OAuthSwift


class ViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet weak var tLoginImg: UIImageView!
    var totalUplift = 0;
    @IBOutlet weak var loadingViewFull: UIView!
    @IBOutlet weak var appName: UILabel!
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var id:String = "id"
    var registrar_id:String = "registrar_id"
    var name:String = "username"
    var email:String = "email"
    var about:String = "bio"
    var picture:String = "picture"
    var signup_method = "method"
    let url = "https://jasontask.azurewebsites.net"
    var usernameString:String?
    var passwordString:String?
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var twitterBtn: TWTRLogInButton!
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        totalUplift += 50
        self.view.frame.origin.y -= CGFloat(totalUplift)
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        
        self.view.frame.origin.y += CGFloat(totalUplift)
        totalUplift = 0
    }
    
    
    func getAllContacts()
    {
        SwiftAddressBook.requestAccessWithCompletion { (b :Bool, _ :CFError?) -> Void in
            if b {
                if let people : [SwiftAddressBookPerson]? = swiftAddressBook!.allPeople {
                    //access variables on any entry of allPeople array just like always
                    print(people!.count)
                    for person in people! {
                        
                        
                        
                        print("name: \(person.firstName) \(person.lastName), number: \(person.phoneNumbers?.map( {$0.value}))")
                        
                        
                        
                       // self.allContacts.append(valuesForContact)
                        
                        
                    }
                    
                    //self.combnineAllContacts()
                    
                }
                
                
                
            }

        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        
       

        
        if let b: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("logout") {
            if (b as! String == "yes")
            {
                print("logout")
                self.loadingViewFull.hidden = true
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.removeObjectForKey("logout")
                userDefaults.removeObjectForKey("id")
                userDefaults.synchronize()
                if (FBSDKAccessToken.currentAccessToken() != nil){
                    var logoutBtn:FBSDKLoginManager = FBSDKLoginManager()
                    logoutBtn.logOut()

                                    }
            }
            
            
            
        }
        else
        {
            print("no logout")
            if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
                
                
                GTToast.create("Signing in... Please wait").show()
                print("Already logged in")
                print(id)
                
                self.registrar_id = id as! String
                checkExistingUserInfo(self.registrar_id)
                
                
            }
        }
        
        getAllContacts()
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.authToken) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                    
                )
                
                self.loginWithTwitter(unwrappedSession.userID)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
                
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.tLoginImg.center
        //self.view.addSubview(logInButton)
        
        logInButton.hidden = false

        
        
        //appName.font = UIFont(name: "Bellerose", size: 25)
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//
//            // User is already logged in, do work such as go to next view controller.
//            if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
//                
//                
//                GTToast.create("Signing in... Please wait").show()
//                print("Already logged in")
//                print(id)
//                
//                self.registrar_id = id as! String
//                checkExistingUserInfo(self.registrar_id)
//
//                
//            }
//        }
//        else
//        {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
            self.fbLoginButton.readPermissions = ["public_profile","email", "user_friends", "user_about_me"]
            self.fbLoginButton.delegate = self
        
        
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
//        }
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(sender: UIButton) {
        
        self.usernameString = username.text
        self.passwordString = password.text
        
        if (username.text != "" && password.text != ""){
            
            signInAttempt(self.usernameString!, password: self.passwordString!)
        }
        else
        {
            print("Didn't in")
        }

        
        
        
    }
    
    func checkExistingUserInfo(id: String)
    {
        
                indicator.startAnimating()
        indicator.color = UIColor.redColor()
        loadingViewFull.hidden = false
        
        print("checking existing user information...")
        var checkurl = "https://jasontask.azurewebsites.net/api/index.php?command=check_registrar&registrar_id="
        checkurl += id
        
        
        Alamofire.request(.GET, checkurl)
            .responseJSON { response in
                
                        self.indicator.stopAnimating()
                let json  = response.result.value as! NSDictionary
                let result = json["result"]! as! [[String : AnyObject]]
                
                if (!result.isEmpty)
                {
                    for r in result {
                        let id = r["id"]! as! String
                        self.registrar_id = r["registrar_id"]! as! String
                        let name = r["username"]! as! String
                        let url = r["profile_pic"] as! String
                        
                        print("account: \(id) \(name)")
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(self.registrar_id, forKey: "id")
                        userDefaults.setObject(name, forKey: "username")
                        userDefaults.setObject(url, forKey: "url")
                        
                        userDefaults.synchronize()
                    }
                    self.performSegueWithIdentifier("loggedin", sender: self)
                }
                else
                {
                    print("not a user already...")
                    print("registering...")
                    
                    self.newUserSignup()
                }
        }
        
    }
    
    func newUserSignup()
    {
     
        var url = "https://jasontask.azurewebsites.net/api/index.php?command=add_social_user&"
        url += "registrar_id="
        url += self.id
        url += "&username="
        url += self.name
        url += "&profile_picture="
        url += self.picture
        url += "&signup_method="
        url += self.signup_method
        url += "&user_about="
        url += self.about
        print("----")
        url = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        print(url)
        print("----")
    }

    
    func signInAttempt(username:String, password:String)
    {
        
        GTToast.create("Signing in... Please wait").show()

        indicator.startAnimating()
        print("it came in")
        
        
        var loginUrl = "https://jasontask.azurewebsites.net/api/index.php?command=login&username=\(username)&password=\(password)"
        loginUrl = loginUrl.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        print(loginUrl)
        
        Alamofire.request(.GET, loginUrl)
            .responseJSON { response in
                debugPrint(response)
                
                        self.indicator.stopAnimating()
                let json  = response.result.value as! NSDictionary
                let result = json["result"] as? [[String : AnyObject]]
                
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if (!(result == nil))
                {
                    for r in result! {
                        let id = r["id"]! as! String
                        self.registrar_id = r["registrar_id"]! as! String
                        let name = r["username"]! as! String
                        let url = r["profile_pic"] as! String
                        
                        print("account: \(id) \(name)")
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(self.registrar_id, forKey: "id")
                        userDefaults.setObject(name, forKey: "username")
                        userDefaults.setObject(url, forKey: "url")
                        
                        userDefaults.synchronize()
                    }
                    self.performSegueWithIdentifier("loggedin", sender: self)
                }
                else
                {

                    let json  = response.result.value!.valueForKey("error")
                    //let error = json["error"] as? [[String : AnyObject]]
                    
                    
                    print("This is the respons: \(json!)")
                    GTToast.create(json as! String).show()
                    self.password.text = ""

                }
        }
    }
    
    
    func loginWithTwitter(userId:String)
    {
        // TODO: Base this Tweet ID on some data from elsewhere in your app
        TWTRAPIClient().loadUserWithID(userId) { (user, error) -> Void in
            
            
            print(user!.profileImageLargeURL)
            
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if (error == nil)
        {
            print("login complete")
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "me", parameters:["fields": "id, name, email, bio, picture"])
            
            
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    // Process error

                }
                else
                {
                    
                    self.id = (result.valueForKey("id") as? String)!
                    self.name = (result.valueForKey("name") as? String)!
                    self.email = (result.valueForKey("email") as? String)!
                    self.about = (result.valueForKey("bio") as? String)!
                    let n = (result.valueForKey("picture") as? NSDictionary)!
                    let m = (n.valueForKey("data") as? NSDictionary)!
                    self.picture = (m.valueForKey("url") as? String)!
                    self.signup_method = "facebook"
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(self.id, forKey: "fbId")
                    userDefaults.synchronize()
                    
                    
                    print(self.id)
//                    print(self.name)
//                    print(self.email)
//                    print(self.about)
//                    print(self.picture)
//                    print(self.signup_method)
                    
                    self.checkExistingUserInfo(self.id)
                    
                }
            })
            
        }
        else
        {
            print("Error: \("nooww")")
            print(error.localizedDescription)
        }
        
        
    }
    
    
//    func loginWithLinkedIn()
//    {
//        
////        let oauthswift = OAuth1Swift(
////            consumerKey:    "77gygs4ovdtya6",
////            consumerSecret: "Lz1OZTCadlVqeGYk",
////            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
////            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
////            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
////        )
////        
////        oauthswift.authorizeWithCallbackURL(
////            NSURL(string: "oauth-swift://oauth-callback/twitter")!,
////            success: { credential, response, parameters in
////                print(credential.oauth_token)
////                print(credential.oauth_token_secret)
////                print(parameters["user_id"])
////            },
////            failure: { error in
////                print(error.localizedDescription)
////            }             
////        )
////        
//        let service: String = "Linkedin"
//        
//        doAuthService(service)
//        
//        
//    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        
        print("user logged out")
                loadingViewFull.hidden = true
    }
    


}

