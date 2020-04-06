//
//  UserService.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/27/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
    
    // Variables
    var user = User()
    var listingCount = Int()
    var favorites = [Listing]()
    var nearest = [Listing]()
    var givings = [Listing]()
    var wishlist = [Wish]()
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var favsListener : ListenerRegistration? = nil
    var nearestListener: ListenerRegistration? = nil
    var givingsListener: ListenerRegistration? = nil
    var wishlistListener: ListenerRegistration? = nil
    
    var isGuest : Bool {
        
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
        })
        
        let favsRef = userRef.collection("favorites")
        favsListener = favsRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Listing.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
        
        let nearestListingsRef = userRef.collection("nearestListings")
        nearestListener = nearestListingsRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let nearListing = Listing.init(data: document.data())
                self.nearest.append(nearListing)
            })
        })
        
        let myGivingsRef = userRef.collection("nearestListings")
        givingsListener = myGivingsRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let givingListing = Listing.init(data: document.data())
                self.givings.append(givingListing)
            })
        })
        
        let wishlistRef = userRef.collection("wishlist")
        wishlistListener = myGivingsRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let wish = Wish.init(data: document.data())
                self.wishlist.append(wish)
            })
        })
        
    }
    
    func favoriteSelected(listing: Listing) {
        print("favsRef in the making")
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites") 
        print("favsRef made")
        if favorites.contains(listing) {
            // We remove it as a favorite
            favorites.removeAll{ $0 == listing }
            favsRef.document(listing.id).delete()
        } else {
            // Add as a favorite.
            favorites.append(listing)
            let data = Listing.modelToData(listing: listing)
            favsRef.document(listing.id).setData(data)
        }
    }
    
    func nearestSelected(listing: Listing) {
        print("nearestListings in the making")
        let nearestListingsRef = Firestore.firestore().collection("users").document(user.id).collection("nearestListings")
        print("nearestlistingsRef made")
        if !nearest.contains(listing) {
            // Add as a nearest listing.
            nearest.append(listing)
            let data = Listing.modelToData(listing: listing)
            nearestListingsRef.document(listing.id).setData(data)
        }
    }
    
    func givingsSelected(listing: Listing) {
        print("givingListings in the making")
        let givingListingsRef = Firestore.firestore().collection("users").document(user.id).collection("givingListings")
        print("givinglistingsRef made")
        if !givings.contains(listing) && listing.username == user.username {
            // Add as a nearest listing.
            givings.append(listing)
            let data = Listing.modelToData(listing: listing)
            givingListingsRef.document(listing.id).setData(data)
        }
    }
    
    func wishlistTypeSelected(wish: Wish) {
        print("wishlist in the making")
        
        let wishlistRef = Firestore.firestore().collection("users").document(user.id).collection("wishlist")
        print("wishlistref made")
        if wishlist.contains(wish) {
            // We remove it as a wish
            wishlist.removeAll{ $0 == wish }
            wishlistRef.document(wish.type).delete()
        }
        else {
            // Add as a wish
            wishlist.append(wish)
            let data = Wish.modelToData(wish: wish)
            wishlistRef.document(wish.type).setData(data)
        }
        
        for item in wishlist {
            if item.type == "" {
                if let index = wishlist.firstIndex(of: item) {
                    wishlist.remove(at: index)
                }
            }
        }
        print(wishlist.description)
    }
 

   
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        nearestListener?.remove()
        nearestListener = nil
        givingsListener?.remove()
        givingsListener = nil
        wishlistListener?.remove()
        wishlistListener = nil
        user = User()
        favorites.removeAll()
        nearest.removeAll()
        givings.removeAll()
        wishlist.removeAll()
    }
}

