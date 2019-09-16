//
//  TableViewCell.swift
//  StudentManagerSimpleApp
//
//  Created by Trương Quang on 9/16/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    var inforContact: InforContact? {
        didSet {
            if let data = inforContact?.image as Data? {
                avatar.image = UIImage(data: data)
            }
            name.text = inforContact?.name
            phoneNumber.text = inforContact?.phoneNumber
            
            avatar.layer.cornerRadius = avatar.bounds.width / 2
            avatar.layer.borderWidth = 1
            avatar.layer.borderColor = UIColor.lightGray.cgColor
            avatar.layer.masksToBounds = true
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
