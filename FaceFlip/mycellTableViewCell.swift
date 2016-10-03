//
//  mycellTableViewCell.swift
//  FaceFlip
//
//  Created by Aqib on 09/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit

class mycellTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
