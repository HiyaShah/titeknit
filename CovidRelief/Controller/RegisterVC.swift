//
//  RegisterVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/22/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseFirestore

class RegisterVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    
    var weatherManager =  LocationManager()
    let locationManager = CLLocationManager()
    var cityName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //startupdatinglocation is for continuous
        
        
        
        
        
        if let passwordTxt = passwordTxt {
            passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
        
        if let confirmPassTxt = confirmPassTxt {
            confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passTxt = passwordTxt.text else {return}
        if textField == confirmPassTxt {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                confirmPassTxt.text = ""
            }
            
        }
        
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImages.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
        } else {
            passCheckImg.image = UIImage(named: AppImages.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty ,
            let username = usernameTxt.text , username.isNotEmpty ,
            let password = passwordTxt.text , password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
                
        }
        
        guard let confirmPass = confirmPassTxt.text ,
            confirmPass == password else {
                simpleAlert(title: "Error", msg: "Passwords don't match.")
                return
        }
        
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            guard let firUser = result?.user else { return }
            let user = User.init(id: firUser.uid, email: email, username: username, city: self.cityName)
            // Upload to Firestore
            self.createFirestoreUser(user: user)
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
            
        }
    
    func createFirestoreUser(user: User) {
        // Step 1: Create document reference
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        
        // Step 2: Create model data
        let data = User.modelToData(user: user)
        
        // Step 3: Upload to Firestore.
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Error signing in: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    }

extension RegisterVC: CLLocationManagerDelegate {


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
//            let distance = getDistanceInKmGivenLonLat(lat1: lat, lat2: lat+1.0, lon1: lon, lon2: lon+1.0)
//            print("Distance to random place is\(distance)")
        }

        // Get user's current location name
        if let lastLocation = locations.last {
            let geocoder = CLGeocoder()

            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                if error == nil {
                    if let firstLocation = placemarks?[0],
                        let city = firstLocation.locality { // get the city name
                        self?.cityName = city
                        
                        self?.locationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    
    func getDistanceInKmGivenLonLat(lat1: Double, lat2: Double, lon1: Double, lon2: Double) -> Double {
        let R = 6371e3; // metres
        let φ1 = lat1.toRadians();
        let φ2 = lat2.toRadians();
        let Δφ = (lat2-lat1).toRadians();
        let Δλ = (lon2-lon1).toRadians();

        let a = sin(Δφ/2) * sin(Δφ/2) +
                cos(φ1) * cos(φ2) *
                sin(Δλ/2) * sin(Δλ/2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));

        let d = R * c;
        return d
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


