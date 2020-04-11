//
//  ListingDetailVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/4/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class ListingDetailVC: UIViewController {

    @IBOutlet weak var usernameCityTxt: UILabel!
    
    @IBOutlet weak var listingNameTxt: UILabel!
    @IBOutlet weak var listingTypeTxt: UILabel!
    @IBOutlet weak var inStock: UILabel!
    
    
    @IBOutlet weak var listingImgView: UIImageView!
    
    @IBOutlet weak var listingDescriptionText: UILabel!
    
    @IBOutlet weak var requestBtn: RoundedButton!
    
    
    var listing : Listing?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let listing = listing {
        listingNameTxt.text = listing.name
            listingTypeTxt.text = listing.type
            if listing.stock > 0{
                inStock.text = "In Stock"
                    inStock.textColor = UIColor.green
            } else {
                inStock.text = "Currently Out Of Stock"
                inStock.textColor = UIColor.red
            }
            listingDescriptionText.text = listing.listingDescription
            usernameCityTxt.text = "kindly listed by \(listing.username) from \(listing.city)"
            
            if let url = URL(string: listing.imgUrl) {
                listingImgView.contentMode = .scaleAspectFill
                listingImgView.kf.setImage(with: url)
            }
            
            if UserService.isGuest || UserService.user.username == listing.username {
                requestBtn.isHidden = true

            }
        }
        self.title = "Listing Details"
    }
    

    @IBAction func requestItemClicked(_ sender: Any) {
            let vc = DeliverQuestionVC()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
        
    }
    
}
