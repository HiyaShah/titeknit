//
//  Constants.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/22/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "loginVC"
    static let TermsVC = "termsVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let Placeholder = "placeholder"
}

struct AppColors {
    static let PastelAquamarine = #colorLiteral(red: 0.8941176471, green: 0.9882352941, blue: 0.9647058824, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9542341828, green: 1, blue: 0.9506618381, alpha: 1)
    static let BlackShadow = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let Orange = #colorLiteral(red: 1, green: 0.5176470588, blue: 0.3882352941, alpha: 1)
    static let NavyBlue = #colorLiteral(red: 0.3418669701, green: 0.3526337147, blue: 0.5360661149, alpha: 1)
    
    
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ListingCell = "ListingCell"
    static let TypesSupportedCell = "TypesSupported"
    
}

struct Segues {
    static let toListingsVC = "toListingsVC"
    static let toFavorites = "toFavorites"
    static let ToAddEditProducts = "ToAddEditProducts"
    static let toUserInfoVC = "toUserInfoVC"
    static let toNearest = "toNearest"
    static let toWishlist = "toWishlist"
    static let toGivings = "toGivings"
    static let toVolunteer = "toVolunteer"
    static let toListingDetails = "toListingDetails"
    static let toWishlistMatches = "toWishlistMatches"
}
