//
//  CategoryCell.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/23/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryLbl: UILabel!
    
    
    @IBOutlet weak var categoryCount: RoundedNotification!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addShadowEffect()
    }
    
    func configureCell(category: Category) {
        categoryLbl.text = category.name
        categoryCount.text = String(UserService.listingCount)
        //only writing the count after seguing to the products vc ah
        print(UserService.listingCount)
        
    }
    
    func addShadowEffect(){
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5.0, height: 0.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
//    @IBAction func favoriteClicked(_ sender: Any) {
//    }
}
 
