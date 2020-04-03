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

class UserInformationVC: UIViewController {
    
    var locationManager =  LocationManager()
    var distanceManager = DistanceManager()
    
    @IBOutlet weak var hometownLbl: UILabel!
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var zipcodeTxt: UITextField!
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLbl: UILabel!
    
    var nearestZipCodes: [String] = UserService.user.nearestZipsToHome
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        distanceManager.delegate = self
        zipcodeTxt.delegate = self
        
        
        usernameTxt.text = UserService.user.username
        emailTxt.text = UserService.user.email
        zipcodeTxt.text = UserService.user.zipcode
        locationManager.fetchCity(zipcode: UserService.user.zipcode)
        hometownLbl.text = UserService.user.city
        let formattedCurrentVal = String(format: "%.1f", UserService.user.areaRadius)
        radiusLbl.text = String("\(formattedCurrentVal) miles")
        radiusSlider.setValue(Float(UserService.user.areaRadius), animated: true)
        
       
        
        
        
        
    }
    
    @IBAction func radiusSlid(_ sender: UISlider) {
        let currentValue = sender.value
        print("Slider changing to \(currentValue) ?")
        let formattedCurrentValue = String(format: "%.1f", currentValue)
        radiusLbl.text = "\(formattedCurrentValue) miles"
        
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty ,
            let username = usernameTxt.text , username.isNotEmpty ,
            let zipcode = zipcodeTxt.text , zipcode.isNotEmpty,
            let areaRadius = Optional(radiusSlider.value) else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
                
        }
        zipcodeTxt.endEditing(true)
        usernameTxt.endEditing(true)
        emailTxt.endEditing(true)
        let hometown = hometownLbl.text ?? ""
        distanceManager.fetchNearest(zipcode: zipcode, distance: Double(radiusSlider.value))
        updateData(email: email, username: username, zipcode: zipcode, city: hometown, areaRadius: Double(areaRadius), nearbyZips: nearestZipCodes)
        
    }
    
    func updateData(email: String, username: String, zipcode: String, city: String, areaRadius: Double, nearbyZips: [String]) {
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        print("zip i am putting in is \(zipcode)")
        print("arearadius is: \(areaRadius)")
        var user = User.init(id: "", email: email, username: username, zipcode: zipcode, city: city, areaRadius: areaRadius, nearestZipsToHome: nearestZipCodes)
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

extension UserInformationVC: UITextFieldDelegate, LocationManagerDelegate, DistanceManagerDelegate {
    
    func didUpdateDistance(_ locationManager: DistanceManager, location: DistanceModel) {
        DispatchQueue.main.async {
            print(location.nearbyZips)
            self.nearestZipCodes = location.nearbyZips
        
        }
    }
    
    
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
            distanceManager.fetchNearest(zipcode: zipcodeTxt.text ?? UserService.user.zipcode, distance: Double(radiusSlider.value))
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
