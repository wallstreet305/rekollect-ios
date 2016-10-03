//
//  ViewNotesForPerson.swift
//  Recollekt
//
//  Created by Aqib on 04/01/2016.
//  Copyright © 2016 CodeArray. All rights reserved.
//

import UIKit

class ViewNotesForPerson: UIViewController {

    @IBOutlet var mainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView.frame.size = CGSizeMake(300, 300)
        

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

}
