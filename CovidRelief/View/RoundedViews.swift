//
//  RoundedViews.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/22/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class RoundedButton : UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = 5
        
    }
}

class RoundedShadowView : UIView {
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 2
//        layer.shadowColor = AppColors.BlackShadow.cgColor
//        layer.shadowOpacity = 1.0
//        layer.shadowOffset = CGSize.zero
//        layer.shadowRadius = 6
    }
}

class RoundedListingsView : UIView {
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 5
//        layer.shadowColor = AppColors.BlackShadow.cgColor
//        layer.shadowOpacity = 1.0
//        layer.shadowOffset = CGSize.zero
//        layer.shadowRadius = 6
    }
}



class RoundedNotification: UILabel {
    override func awakeFromNib() {
        layer.cornerRadius = frame.width/3
        self.textColor = UIColor.white
        layer.backgroundColor = AppColors.Orange.cgColor
//        self.backgroundColor = UIColor.red
      
    }
}

class RoundedImageView : UIImageView {
    override func awakeFromNib() {
        layer.cornerRadius = 5
    }
}
