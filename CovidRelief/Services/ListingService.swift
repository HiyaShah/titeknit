//
//  ListingService.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/11/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

let ListingService = _ListingService()

final class _ListingService {
    
    // Variables
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var listingListener : ListenerRegistration? = nil
    var requestListener : ListenerRegistration? = nil
    var requests = [User]()

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
    
    func getCurrentListing(listing: Listing, user: User) {
        guard let authUser = auth.currentUser else { return }
        
        let listingRef = db.collection("listing").document(listing.id)
        listingListener = listingRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
//            self.listing = Listing.init(data: data)
        })
        
        let requestRef = listingRef.collection("requests")
        requestListener = requestRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let req = User.init(data: document.data())
                self.requests.append(req)
            })
        })
        
        
        
    }
    
    func requestMade(listing: Listing, user: User) {
        print("ref in the making")
        let reqRef = Firestore.firestore().collection("listings").document(listing.id).collection("requests")
        print("ref made")
        if requests.contains(user) {
            // We remove it as a favorite
            requests.removeAll{ $0 == user }
            reqRef.document(listing.id).delete()
        } else {
            // Add as a favorite.
            requests.append(user)
            let data = User.modelToData(user: user)
            reqRef.document(listing.id).setData(data)
        }
    }
    
    
   
    func logoutUser() {
        listingListener?.remove()
        requestListener = nil
        requests.removeAll()
    }
}



