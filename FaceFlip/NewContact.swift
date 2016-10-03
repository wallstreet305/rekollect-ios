//
//  NewContact.swift
//  FaceFlip
//
//  Created by Aqib on 15/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit





class NewContact: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var v: UIView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    var contactName:String!
    var imagePicker = UIImagePickerController()
    var userid:String!
    var groupid:String!
    
    
    
    @IBOutlet weak var contactImage: UIImageView!
    
    @IBAction func addContact(sender: UIButton) {
        
        if (nametext.text != "")
        {
            v.hidden = false
            myImageUploadRequest()
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter the name first.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBOutlet weak var nametext: UITextField!
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        contactImage.image = image
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //myActivityIndicator.hidden = true
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("id") {
            self.userid = id as! String
            
        }
        else
        {
            print("not set")
        }
        
        if let id: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("currentGpID") {
            self.groupid = id as! String
            
        }
        
        if (contactName != nil)
        {
            nametext.text = contactName
        }
        // Do any additional setup after loading the view.
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        contactImage.userInteractionEnabled = true
        contactImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        
    }
    
    func imageTapped(img: AnyObject)
    {
        print("Image Tapped")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func myImageUploadRequest()
    {
        
        var name:String = nametext.text!
        let myUrl = NSURL(string: "http://jasontask.azurewebsites.net/api/upload.php");
        //let myUrl = NSURL(string: "https://lfk.azurewebsites.net/upload.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        print ("userid:  \(userid), groupid: \(groupid), name:\(name)")
        
        let param = [
            "userid"  : "\(userid)",
            "group"    : "\(groupid)",
            "name"    : "\(name)"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(contactImage.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        myActivityIndicator.hidden = false
        
        myActivityIndicator.startAnimating();
        
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
            
            
            
            self.dismissViewControllerAnimated(true, completion: nil);
            
            //self.performSegueWithIdentifier("contactHasBeenAddedYes", sender: self)
            
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
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
