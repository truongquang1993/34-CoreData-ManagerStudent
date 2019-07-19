//
//  MyTableViewCell.swift
//  3400 CoreData 08
//
//  Created by Trương Quang on 7/15/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var outletImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phonenumber: UILabel!
    
    var inforStudent: InforManager? {
        didSet {
            outletImage.image = UIImage(data: inforStudent?.image as! Data)
            name.text = inforStudent?.name
            phonenumber.text = inforStudent?.phonenumber
            
            outletImage.layer.cornerRadius = outletImage.bounds.width / 2
            outletImage.layer.borderWidth = 1
            outletImage.layer.borderColor = UIColor.lightGray.cgColor
            outletImage.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
