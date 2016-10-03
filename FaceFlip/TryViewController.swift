extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

//
//  TryViewController.swift
//  FaceFlip
//
//  Created by Aqib on 10/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import UIKit
import GTToast
import Alamofire
import KFSwiftImageLoader
import SwiftAddressBook
import Foundation
import SCLAlertView






extension String {
    var length: Int { return characters.count    }  // Swift 2.0
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}


class TryViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate , UITextViewDelegate {
    
    @IBOutlet weak var imgChange: UIButton!
    var id:String!
    var im:UIImage!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var viewNotesBtn: UIButton!
    
    @IBOutlet weak var uploadingDialog: UIView!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder();
            
            
            editTapped(textView.text)
            
            
            
            return false;
        }
        
        return true;
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        
        return .None
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 10
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        
        let filename = "user-image-\(randomStringWithLength(15)).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
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
    
    
    @available(iOS 2.0, *)
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        //
        //        if (cell == nil)
        //        {
        tableView.registerNib(UINib.init(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("noteCell") as! NotesTableViewCell
        // }
        
        //cell.
        
        return cell
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showNotes")
        {
            var destination = segue.destinationViewController as! UIViewController
            var controller = destination.popoverPresentationController
            
            if (controller != nil)
            {
                controller?.delegate = self
            }
        }
    }
    @IBAction func changePhoto(sender: UIButton) {
        
        print("Image Tapped")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func viewNotes(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showNotes", sender: self)
    }
    
    var noteOnIndex:String!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    var count:Int = 0;
    var groupID:String = "abc"
    var allContacts: [contact] = []
    var containerView = UIView()
    var userid:String!
    var currentNumber:Int!
    
    func createGp(img: AnyObject)
    {
        print("YESS")
        //createGroupButtonDown(UIButton())
    }
    
    
    
    
    
    @IBAction func ViewNotesForPerson(sender: UIButton) {
        
        
        if (sender.tag == 0)
        {
            sender.tag = 1
            UIView.animateWithDuration(0.4, animations: {
                sender.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
            
            
            
            var page = scrollView.contentOffset.x / scrollView.frame.size.width;
            
            page+=1
            
            
            
            print("page number= \(page)")
            
            currentNumber = Int(page)
            
            //noteOnIndex = allContacts[currentNumber-1].notes.note
            
            
            let subView = self.scrollView.subviews[self.currentNumber-1] as! scrollViewItem
            //  print(sub.opaque)
            
            subView.userInteractionEnabled = true
            
            subView.topSpace.constant = -220
            
            UIView.animateWithDuration(0.4){
                self.view.layoutIfNeeded()
            }
            
            
            
            //            dispatch_async(dispatch_get_main_queue(), {
            //                
            //                
            //                let subView = self.scrollView.subviews[self.currentNumber-1] as! scrollViewItem
            //                //  print(sub.opaque)
            //                
            //                subView.userInteractionEnabled = true
            //                
            //                subView.topSpace.constant = -220
            //                
            //                UIView.animateWithDuration(0.4){
            //                    self.view.layoutIfNeeded()
            //                }
            //            })
            
            
            
            
        }
        else
        {
            sender.tag = 0
            UIView.animateWithDuration(0.4, animations: {
                sender.transform = CGAffineTransformMakeRotation((0.0 * CGFloat(M_PI)) / 180.0)
            })
            
            
            
            var page = scrollView.contentOffset.x / scrollView.frame.size.width;
            
            page+=1
            
            
            
            print("page number= \(page)")
            
            currentNumber = Int(page)
            
            //noteOnIndex = allContacts[currentNumber-1].notes.note
            
            
            let subView = self.scrollView.subviews[self.currentNumber-1] as! scrollViewItem
            //  print(sub.opaque)
            
            subView.userInteractionEnabled = true
            
            subView.topSpace.constant = 0
            
            UIView.animateWithDuration(0.4){
                self.view.layoutIfNeeded()
            }
            
            
            //            dispatch_async(dispatch_get_main_queue(), {
            //                
            //                let subView = self.scrollView.subviews[self.currentNumber-1] as! scrollViewItem
            //                //  print(sub.opaque)
            //                
            //                subView.userInteractionEnabled = true
            //                
            //                subView.topSpace.constant = 0
            //                
            //                UIView.animateWithDuration(0.4){
            //                    self.view.layoutIfNeeded()
            //                }
            //
            //            })
            
            
            
        }
        
        
    }
    
    
    
    func editTapped(str:String)
    {
        
        let groupName = str
        
        if (1 == 1)
        {
            
            var page = scrollView.contentOffset.x / scrollView.frame.size.width;
            page+=1
            print("page number= \(page)")
            
            currentNumber = Int(page)
            
            
            //self.createGroup(self.id, name: groupName!, secretCode: secretCode as String)
            
            //http://jasontask.azurewebsites.net/api/index.php?command=addNotes&user_id=917093491659259&contact_id=62&note=hellowwor
            
            print("user-id:\(self.userid)")
            print("contact-id:\(self.allContacts[self.currentNumber-1].contact_id)")
            print("note:\(groupName)")
            
            
            
            GTToast.create("Updating Notes. Please wait...").show()
            var apiCall = "http://jasontask.azurewebsites.net/api/index.php?command=addNotes&user_id=\(self.userid)&contact_id=\(self.allContacts[self.currentNumber-1].contact_id)&note=\(groupName)"
            
            apiCall = apiCall.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            print(apiCall)
            
            Alamofire.request(.GET, apiCall)
                .responseString { response in
                    if (response.result.value != nil)
                    {
                        print("Response String: \(response.result.value)")
                        GTToast.create(response.result.value!).show()
                        //self.allContacts = []
                        
                        if (response.result.value?.lowercaseString.rangeOfString("successfully") != nil)
                        {
                            //self.allContacts[self.currentNumber-1].notes.note = groupName!
                            self.allContacts = []
                            //                self.getContactsForGroup(self.groupID)
                            
                        }
                        
                        //self.getContactsForGroup(self.groupID)
                    }
            }
            
            
        }
        else
        {
            print("Enter note or press cancel")
        }
        
        
        
        
    }
    
    func myImageUploadRequest()
    {
        
        // var name:String = nametext.text!
        let myUrl:NSURL!
        myUrl = NSURL(string: "http://jasontask.azurewebsites.net/api/changepicture.php");
        //let myUrl = NSURL(string: "https://lfk.azurewebsites.net/upload.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        var page = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        print("page number= \(page)")
        
        currentNumber = Int(page)
        
        
        let param = [
            "userid"  : "\(self.id)",
            "contactid"    : "\(self.allContacts[currentNumber].contact_id)",
        ]
        
        
        
        print("myUrl: \(myUrl) params: userid=\(self.id), contactid=\(self.allContacts[currentNumber].contact_id)");
        
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(im, 0)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            //self.performSegueWithIdentifier("contactAdded", sender: self)
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject("yes", forKey: "contactAdded")
            userDefaults.synchronize()
            
            //self.dismissViewControllerAnimated(true, completion: {});
            
            
            GTToast.create("Photo uploaded").show()
            
            
            
            self.viewDidLoad()
            
            
            //            self.performSegueWithIdentifier("contactHasBeenAddedYes", sender: self)
            
            //unwindForSegue(<#T##unwindSegue: UIStoryboardSegue##UIStoryboardSegue#>, towardsViewController: <#T##UIViewController#>)
            
            //            do{
            //             let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
            //                print(json)
            //            } catch {
            //
            //            }
            
            
            
            
            
            //            dispatch_async(dispatch_get_main_queue(),{
            //                self.myActivityIndicator.stopAnimating()
            //                    self.contactImage.image = nil;
            //            });
            
            /*
            if let parseJSON = json {
            var firstNameValue = parseJSON["firstName"] as? String
            println("firstNameValue: \(firstNameValue)")
            }
            */
            
        }
        
        task.resume()
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        self.uploadingDialog.hidden = false
        animator.startAnimating()
        im = image
        
        //im = UIImage(named: "bg")
        
        myImageUploadRequest()
        
    }
    
    @IBAction func optionButtonPressed(sender: UIBarButtonItem) {
        
        more(sender)
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        print ("text here: \(textView.text!)")
        if textView.text! == "No Notes Added" {
            textView.text = nil
        }
    }
    
    
    
    @IBOutlet weak var animator: UIActivityIndicatorView!
    
    func setAllViews()
    {
        //self.scrollView.frame = CGRectMake(0,0, self.view.frame.width, self.view.frame.height)
        let navBarHeight = self.navigationController!.navigationBar.frame.size.height
        let ScrollViewHeight = self.scrollView.frame.height
        let ScrollViewWidth = self.scrollView.frame.width
        
        //        containerView = UIView()
        //        containerView.userInteractionEnabled = true
        
        
        //   self.scrollView.addSubview(containerView)
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        for i in 0...self.count-1{
            
            //var view = scrollViewItem(frame: CGRectMake(ScrollViewWidth*CGFloat(i),0, ScrollViewWidth, ScrollViewHeight))
            
            
            var view = scrollViewItem.instanceFromNib()
            view.frame = CGRectMake(ScrollViewWidth*CGFloat(i),0, ScrollViewWidth, ScrollViewHeight)
            view.logo.loadImageFromURLString(allContacts[i].picture as! String, placeholderImage: UIImage(named: "loading")) {
                (finished, error) in
            }
            
            view.userInteractionEnabled = true
            
            
            
            view.name.text = self.allContacts[i].name
            
            
            if (self.allContacts[i].notes != "Note has been added")
            {
                view.note.text = self.allContacts[i].notes
            }
            else
            {
                view.note.text = self.allContacts[i].notes
            }
            
            
            view.note.delegate = self;
            
            
            
            //            if (self.allContacts[i].notes.note.length>30)
            //            {
            //                // view.note.text = (self.allContacts[i].notes.note)
            //            }
            //            else
            //            {
            //                //view.note.text = (self.allContacts[i].notes.note)
            //                //view.note.text = (self.allContacts[i].notes.note).substringByInt(0, 28)
            //            }
            
            
            let singleTap = UIGestureRecognizer(target: self, action:Selector("createGp:"))
            singleTap.cancelsTouchesInView = false
            scrollView.addGestureRecognizer(singleTap)
            
            view.note.userInteractionEnabled = true
            
            view.note.addGestureRecognizer(singleTap)
            
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("createGp:"))
            view.userInteractionEnabled = true
            view.addGestureRecognizer(tapGestureRecognizer)
            
            
            print(i)
            self.scrollView.addSubview(view)
            self.scrollView.addGestureRecognizer(singleTap)
            
            
            
            
            self.scrollView.userInteractionEnabled = true
            
            
        }
        
        
        
        
        
        //let flt:CGFloat = 5.0 + self.scrollView.frame.width
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*CGFloat(self.count), self.scrollView.frame.height)
        
        
        
        
        
        scrollView.userInteractionEnabled = true
        
        scrollView.delaysContentTouches = false
        
        scrollView.canCancelContentTouches = false
        
        
    }
    
    
    func more(sender: UIBarButtonItem) {
        
        
        var page = scrollView.contentOffset.x / scrollView.frame.size.width;
        page+=1
        print("page number= \(page)")
        
        currentNumber = Int(page)
        
        
        let alertView = SCLAlertView()
        
        
        alertView.addButton("Add Contacts") {
            print("Add Contacts pressed")
            
            self.addContactsOptions()
            
        }
        
        alertView.addButton("Cancel") {
            print("Second button tapped")
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
        
        
        alertView.showCloseButton = false
        
        //   alertView.
        
        //        alertView.showSuccess("Options", subTitle: "Select your desired option.")
        
        alertView.showTitle("Options", // Title of view
            subTitle: "Select your desired option.", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: nil, // Optional button value, default: ""
            style: .Info, // Styles - see below.
            colorStyle: 0xE34D4E,
            colorTextButton: 0xFFFFFF
        )
        
        
        
        
        //        let alert = UIAlertController(title: "Options", message: "You can Manage Notes or Add Contacts.", preferredStyle: UIAlertControllerStyle.Alert)
        //        
        //        
        //        
        //        let notesOption = UIAlertAction(title: "Notes", style: UIAlertActionStyle.Default) {
        //            
        //            UIAlertAction in
        //            print("Notes")
        //            //self.editTapped()
        //            
        //        }
        //        let contactsOption = UIAlertAction(title: "Add Contact", style: UIAlertActionStyle.Default) {
        //            
        //            UIAlertAction in
        //            print("Contacts")
        //            self.addContactsOptions()
        //            
        //        }
        //        
        //        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
        //            
        //            UIAlertAction in
        //            print("Cancel")
        //            alert.dismissViewControllerAnimated(true, completion: nil)
        //            
        //        }
        //        
        ////        if (allContacts.count>0)
        ////        {
        ////            alert.addAction(notesOption)
        ////        }
        //        
        //        alert.addAction(contactsOption)
        //        
        //        alert.addAction(cancelOption)
        //        
        //        self.presentViewController(alert, animated: true, completion: nil)
        //        
        //        
        
        
    }
    
    @IBAction func swipeGesture(sender: UISwipeGestureRecognizer) {
        
        let a = UIButton()
        a.tag = 0
        ViewNotesForPerson(a)
        
    }
    
    func addContactsOptions() {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        //self.navigationController?.popViewControllerAnimated(true)
        print("Button tapped")
        
        
        
        let alertView = SCLAlertView()
        
        
        alertView.addButton("Address Book") {
            print("address book")
            self.performSegueWithIdentifier("address", sender: self)
            
        }
        
        alertView.addButton("New Contact") {
            print("new Contact")
            self.performSegueWithIdentifier("newContact", sender: self)
        }
        
        alertView.addButton("Cancel") {
            print("Cancel")
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
        alertView.showCloseButton = false
        
        alertView.showTitle("Add Contacts", // Title of view
            subTitle: "You can add contacts by two ways.", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: nil, // Optional button value, default: ""
            style: .Info, // Styles - see below.
            colorStyle: 0xE34D4E,
            colorTextButton: 0xFFFFFF
        )
        
        
        //        let alert = UIAlertController(title: "Add Contact", message: "You can add contacts by two ways.", preferredStyle: UIAlertControllerStyle.Alert)
        //        
        //        
        //        
        //        let address = UIAlertAction(title: "Address Book", style: UIAlertActionStyle.Default) {
        //            
        //            UIAlertAction in
        //            print("address book")
        //            
        //            self.performSegueWithIdentifier("address", sender: self)
        //        }
        //        
        //        let newCon = UIAlertAction(title: "New Contact", style: UIAlertActionStyle.Cancel) {
        //            
        //            UIAlertAction in 
        //            print("new Contact")
        //            self.performSegueWithIdentifier("newContact", sender: self)
        //            
        //            
        //        }
        //        
        //        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
        //            
        //            UIAlertAction in
        //            print("Cancel")
        //            alert.dismissViewControllerAnimated(true, completion: nil)
        //            
        //        }
        //        
        //        
        //        alert.addAction(cancelOption)
        //        alert.addAction(address)
        //        alert.addAction(newCon)
        //        
        //        
        //        self.presentViewController(alert, animated: true, completion: nil)
        //        
        
        
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //        self.getContactsForGroup(self.groupID)
        //        
        //        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            self.id = id as! String
            
            
        }
        else
        {
            print("not set")
        }
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        
        print("it came here....")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        
        
        scrollView.panGestureRecognizer.delaysTouchesBegan = false;
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            self.userid = id as! String
            
        }
        else
        {
            print("not set")
        }
        
        self.title = "Contacts"
        
        //        var More : UIBarButtonItem = UIBarButtonItem(title: "...", style: UIBarButtonItemStyle.Plain, target: self, action: "more:")
        //        //More.image = UIImage(named: "btn1")
        //        
        //        More.tintColor = UIColor.whiteColor()
        //        self.navigationItem.rightBarButtonItem = More
        
        
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("currentGpID") {
            self.groupID = id as! String
            
        }
        
        
        
        
        print(self.groupID)
        getContactsForGroup(self.groupID)
        
        
        
        //        view0.view = UIView.loadFromNibNamed("scrollViewItem")
        //        view1.view = UIView.loadFromNibNamed("scrollViewItem")
        //        view2.view = UIView.loadFromNibNamed("scrollViewItem")
        //        view3.view = UIView.loadFromNibNamed("scrollViewItem")
        //        view4.view = UIView.loadFromNibNamed("scrollViewItem")
        //        view5.view = UIView.loadFromNibNamed("scrollViewItem")
        
        
        
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as CGFloat
        
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.frame = CGRectMake(0, (self.view.frame.origin.y - keyboardHeight + 50), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as CGFloat
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.frame = CGRectMake(0, (self.view.frame.origin.y + keyboardHeight - 50), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getContactsForGroup(id: String)
    {
        if (scrollView != nil)
        {
            scrollView.subviews.map({ $0.removeFromSuperview() })
        }
        
        
        
        
        allContacts = []
        GTToast.create("Loading contacts. Please wait...").show()
        var apiCall = "http://jasontask.azurewebsites.net/api/index.php?command=loadGroupPeople&user_id=\(self.userid)&group_id=\(id)"
        
        print(apiCall)
        
        Alamofire.request(.GET, apiCall)
            .responseJSON { response in
                
                let json  = response.result.value as! NSDictionary
                let result = json["result"] as! [[String : AnyObject]]
                
                self.allContacts = []
                
                if (!result.isEmpty)
                {
                    for r in result {
                        
                        let id = r["contact_id"]! as! String
                        let by = r["added_by"]! as! String
                        let gp = r["group_id"]! as! String
                        let name = r["name"]! as! String
                        let picture = r["picture"] as! String
                        let notes = r["notes"] as! String //[[String:String]]
                        
                        var allNotes:[[String:String]]
                        allNotes = []
                        
                        
                        //                        if (!notes.isEmpty)
                        //                        {
                        //                            for x in notes{
                        //                                var n:[String:String]
                        //                                n = x
                        //                                
                        //                                allNotes.append(n)
                        //                            }
                        //                        }
                        
                        
                        
                        
                        
                        
                        //                        if (notes == nil)
                        //                        {
                        //                            c = contact(id:id, by:by, gp:gp, name:name, picture:picture, added:" ", notes:n)
                        //                        }
                        //                        else
                        //                        {
                        var c:contact!
                        c = contact(id:id, by:by, gp:gp, name:name, picture:picture, added:" ", notes:notes)
                        // }
                        
                        self.allContacts.append(c)
                        
                    }
                    
                    print(self.allContacts.count)
                    self.count = self.allContacts.count
                    self.setAllViews()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        
                        self.animator.stopAnimating()
                        self.uploadingDialog.hidden = true
                    })
                    
                    
                    
                    //                    self.tableView.reloadData()
                    //self.performSegueWithIdentifier("joinedGroups", sender: self)
                    
                }
                else
                {
                    self.viewNotesBtn.hidden = true
                    self.imgChange.hidden = true
                    GTToast.create("No members in this group.").show()
                }
        }
        
        
    }
    
    
    
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



