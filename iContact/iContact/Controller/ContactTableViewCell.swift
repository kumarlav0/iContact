//
//  AppDelegate.swift
//  iContact
//
//  Created by apple on 27/08/19.
//  Copyright © 2019 apple. All rights reserved.
// Email: kumarstslav@gmail.com


import UIKit



class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var cellCardView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellNameLable: UILabel!
    @IBOutlet weak var cellNumberLable: UILabel!
    
    @IBOutlet weak var cellCheckButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellImageView.layer.cornerRadius = self.cellImageView.frame.height / 2
        self.cellImageView.clipsToBounds = true
        
        
        cellCardView.layer.cornerRadius = 5
        cellCardView.layer.shadowColor = UIColor.black.cgColor
        cellCardView.layer.shadowOpacity = 0.3
        cellCardView.layer.shadowRadius = 3
        cellCardView.layer.shadowOffset = CGSize(width: -1, height: -1)
        cellCardView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
