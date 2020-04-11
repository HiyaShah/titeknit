//
//  ListingCell.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/27/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Kingfisher

protocol ListingCellDelegate : class {
    func listingFavorited(listing: Listing)
    func listingNearest(listing: Listing)
    func listingGiven(listing: Listing)
    func listingWishlistMatched(listing: Listing)
}

class ListingCell: UITableViewCell {

    
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var listingImg: RoundedImageView!
    
    @IBOutlet weak var listingTitle: UILabel!
    
    @IBOutlet weak var stockCount: RoundedNotification!
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    weak var delegate : ListingCellDelegate?
    private var listing: Listing!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(listing: Listing, delegate: ListingCellDelegate) {
        
        self.listing = listing
        self.delegate = delegate
        listingTitle.text = listing.name
        stockCount.text = String(listing.stock)
        usernameLbl.text = "\(listing.username), \(listing.city)"
        typeLbl.text = listing.type


        
        
        if let url = URL(string: listing.imgUrl){
            let placeholder = UIImage(named: "placeholder")
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            listingImg.kf.indicatorType = .activity
            listingImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
//        if(UserService.user.nearestZipsToHome.contains(listing.getZip())){
//            delegate.listingNearest(listing: listing)
//        }
        
        if UserService.favorites.contains(listing) {
            favoriteBtn.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
        
        if listing.username == UserService.user.username {
            delegate.listingGiven(listing: listing)
        }
        
        delegate.listingWishlistMatched(listing: listing)
    }
    
    
    @IBAction func messageBtnClicked(_ sender: Any) {

        if let url = URL(string: "mailto:\(UserService.user.email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.listingFavorited(listing: listing)
    }
}
