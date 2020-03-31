//
//  UserInformationVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/29/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseFirestore

class UserInformationVC: UIViewController, LocationManagerDelegate {
    
    var locationManager =  LocationManager()

    
    @IBOutlet weak var hometownLbl: UILabel!
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var zipcodeTxt: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxt.text = UserService.user.username
        emailTxt.text = UserService.user.email
        zipcodeTxt.text = UserService.user.zipcode
        hometownLbl.text = UserService.user.city
//        print("\(username) and \(email) and \(zipcode)")
        
        
//        guard let authUser = Auth.auth().currentUser else {
//            return
//        }
//        let docRef = Firestore.firestore().collection("users").document(authUser.uid)
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                self.usernameTxt.text = String(describing: document.get("username"))
//
//                // firstSentence == "Hi there!"
//                self.emailTxt.text = document.get("email").debugDescription
//                self.cityTxt.text = document.get("zipcode").debugDescription
//                print("Document data: \(self.usernameTxt.text)")
//
//            } else {
//                print("Document does not exist")
//            }
//        }

       locationManager.delegate = self
       zipcodeTxt.delegate = self
        
        
        
        
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty ,
            let username = usernameTxt.text , username.isNotEmpty ,
            let zipcode = zipcodeTxt.text , zipcode.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
                
        }
        zipcodeTxt.endEditing(true)
        usernameTxt.endEditing(true)
        emailTxt.endEditing(true)
        let hometown = hometownLbl.text ?? ""
        updateData(email: email, username: username, zipcode: zipcode, city: hometown)
        
    }
    
    func updateData(email: String, username: String, zipcode: String, city: String) {
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        print("zip i am putting in is \(zipcode)")
        print("city in UIVC is:")
        var user = User.init(id: "", email: email, username: username, zipcode: zipcode, city: city)
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
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}

extension UserInformationVC: UITextFieldDelegate {
    
    func didUpdateLocation(_ locationManager: LocationManager, location: LocationModel) {
        DispatchQueue.main.async {
            print(location.cityName)
            self.hometownLbl.text = location.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
        return
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        zipcodeTxt.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let zip = zipcodeTxt.text {
            locationManager.fetchCity(zipcode: zip)
        }

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != " "{
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}
