//
//  WishlistVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/2/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class WishlistVC: UIViewController, TypeSupportedCellDelegate {
    
    
    
    
    @IBOutlet weak var selectionLbl: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var db : Firestore!
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        let sortedListingTypesSupported = CategoryInformation.listingTypesSupported.sorted { $0.self < $1.self }
        CategoryInformation.listingTypesSupported = sortedListingTypesSupported
        print(CategoryInformation.listingTypesSupported.description)
        db = Firestore.firestore()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.TypesSupportedCell, bundle: nil), forCellReuseIdentifier: Identifiers.TypesSupportedCell)
//        searchTextField.delegate = self
        
    }
    

    
    
    func typeSelected(wish: String) {
        print("type wished")
        if UserService.isGuest {
            self.simpleAlert(title: "Hello Neighbor!", msg: "Please create a free account to wishlist this type and take advantage of all our features.")
            return
        }
        
        updateData(wish: wish)
        
        selectionLbl.text = String(UserService.user.wishes.count)
        guard let index = CategoryInformation.listingTypesSupported.firstIndex(of: wish) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func updateData(wish: String) {
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        var arr = [String]()
        for item in UserService.user.wishes {
            arr.append(item)
        }
        if arr.contains(wish){
            arr.removeAll{ $0 == wish }
        } else {
            arr.append(wish)
        }
        
        var user = User.init(id: "", email: UserService.user.email, username: UserService.user.username, zipcode: UserService.user.zipcode, city: UserService.user.city, areaRadius: UserService.user.areaRadius, nearestZipsToHome: UserService.user.nearestZipsToHome, wishes: arr)
        let sameUserRef : DocumentReference!
        sameUserRef = Firestore.firestore().collection("users").document(authUser.uid)
        user.id = authUser.uid
        print(user.id)


        let data = User.modelToData(user: user)
        print("about to set data")
        sameUserRef.setData(data, merge: true) { (error) in

            if error != nil {
                self.simpleAlert(title: "Error", msg: "Unable to upload Firestore document.")
                print("did not set data")
                return
            }
            print("set data")
        }
    }
    
    
    
    
    
}


extension WishlistVC: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryInformation.listingTypesSupported.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.TypesSupportedCell, for: indexPath) as? TypesSupported {
            cell.configureCell(wish: CategoryInformation.listingTypesSupported[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}




//extension WishlistVC: UITextFieldDelegate {
//
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextField.endEditing(true)
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let searchItem = searchTextField.text {
//            if CategoryInformation.listingTypesSupported.contains(searchItem){
//                tableView.deleteRows(at: [IndexPath(row: CategoryInformation.listingTypesSupported.firstIndex(of: searchItem)!, section: 0)], with: .fade)
//            }
//        }
//        searchTextField.text = ""
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != " "{
//            return true
//        } else {
//            textField.placeholder = "Search something"
//            return false
//        }
//    }
//}
