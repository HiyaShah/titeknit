//
//  RequestCellTableViewCell.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/11/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class RequestCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userCityLbl: UILabel!
    
    @IBOutlet weak var messageBtn: UIButton!
    
    var user = User()
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBtn.isHidden = true
    }
    
    func configureCell(user: User, isGiver: Bool){
        self.user = user
        userCityLbl.text = "\(user.username), \(user.city)"
        if isGiver {
            messageBtn.isHidden = false
        }
    }
    
    
    @IBAction func messageBtnClicked(_ sender: Any) {
        if let url = URL(string: "mailto:\(user.email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
        
    }
    
    
}
