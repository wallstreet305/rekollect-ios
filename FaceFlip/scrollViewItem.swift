//
//  scrollViewItem.swift
//  FaceFlip
//
//  Created by Aqib on 10/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import Foundation


class scrollViewItem: UIView {
    
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var editButton: UIImageView!
    
    
    var notes:[[String:String]]!
    
    class func instanceFromNib() -> scrollViewItem {
        return UINib(nibName: "scrollViewItem", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! scrollViewItem
    }
    
    
    
//    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        
//        return notes.count
//        
//    }
//    
//    @available(iOS 2.0, *)
//    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    {
//        
//        
//        //        
//        //        if (cell == nil)
//        //        {
//        tableView.registerNib(UINib.init(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
//        
//        var cell = tableView.dequeueReusableCellWithIdentifier("noteCell") as! NotesTableViewCell
//        // }
//        
//        cell.noteText.text = notes[indexPath.row]["note"]
//        
//        
//        return cell
//    }
//    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    
    public class note{
        
        var id:String
        var note:String
        
        init(id:String, note:String)
        {
            self.id = id
            self.note = note
        }
    }
    
}



