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

    
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var cityTxt: UITextField!
    
    var weatherManager =  LocationManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        let docRef = Firestore.firestore().collection("users").document(authUser.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.usernameTxt.text = document.get("username").debugDescription
                self.emailTxt.text = document.get("email").debugDescription
                self.cityTxt.text = document.get("city").debugDescription
                print("Document data: \(self.usernameTxt.text)")
            } else {
                print("Document does not exist")
            }
        }
        
        print("username is \(String(describing: usernameTxt.text))")
        emailTxt.text = UserService.getEmail()
        print("email is \(String(describing: emailTxt.text))")
        print("city i am starting out with is \(UserService.getCity())")
        cityTxt.text = UserService.getCity()
        print("city is \(String(describing: cityTxt.text))")
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //startupdatinglocation is for continuous
        
        
        weatherManager.delegate = self
        
        
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty ,
            let username = usernameTxt.text , username.isNotEmpty ,
            let city = cityTxt.text , city.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
                
        }
//        UserService.user.city = city
//        UserService.user.username = username
//        UserService.user.email = email
//        UserService.getCurrentUser()
        updateData(email: email, username: username, city: city)
        
    }
    
    func updateData(email: String, username: String, city: String) {
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        print("city i am putting in is \(city)")
        var user = User.init(id: "", email: email, username: username, city: city)
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
//            self.navigationController?.popViewController(animated: true)
        }
    }
    

}

//MARK: - CLLocationManagerDelegate

extension UserInformationVC: LocationManagerDelegate {
    func didUpdateWeather(_ weatherManager: LocationManager, weather: LocationModel) {
        DispatchQueue.main.async {
//            self.updateData(email: UserService.user.email, username: UserService.user.username, city: weather.cityName)
            self.cityTxt.text = weather.cityName
            
            UserService.user.country = weather.countryName
            UserService.user.lat = weather.latitude
            UserService.user.lon = weather.longitude
            
        }
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension UserInformationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchLocation(latitude: lat, longitude: lon)
            
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

extension Double {
    
    func toRadians() -> Double {
        return self * Double.pi/180
    }
}






//extension UserInformationVC: CLLocationManagerDelegate {
//
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
//        if let location = locations.last {
//            locationManager.stopUpdatingLocation()
//            let lat = location.coordinate.latitude
//            let lon = location.coordinate.longitude
////            let distance = getDistanceInKmGivenLonLat(lat1: lat, lat2: lat+1.0, lon1: lon, lon2: lon+1.0)
////            print("Distance to random place is\(distance)")
//        }
//
//        // Get user's current location name
//        if let lastLocation = locations.last {
//            let geocoder = CLGeocoder()
//
//            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
//                if error == nil {
//                    if let firstLocation = placemarks?[0],
//                        let cityName = firstLocation.locality { // get the city name
//                        print("I have retrieved the \(cityName)")
//                        self?.cityTxt.text = cityName
//                        self?.locationManager.stopUpdatingLocation()
//                    }
//                }
//            }
//        }
//    }
    
//    func getDistanceInKmGivenLonLat(lat1: Double, lat2: Double, lon1: Double, lon2: Double) -> Double {
//        let R = 6371e3; // metres
//        let φ1 = lat1.toRadians();
//        let φ2 = lat2.toRadians();
//        let Δφ = (lat2-lat1).toRadians();
//        let Δλ = (lon2-lon1).toRadians();
//
//        let a = sin(Δφ/2) * sin(Δφ/2) +
//                cos(φ1) * cos(φ2) *
//                sin(Δλ/2) * sin(Δλ/2);
//        let c = 2 * atan2(sqrt(a), sqrt(1-a));
//
//        let d = R * c;
//        return d
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }



