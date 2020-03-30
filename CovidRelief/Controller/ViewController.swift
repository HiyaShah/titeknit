//
//  ViewController.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/22/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import MapKit

class ViewController: UIViewController {

    
    @IBOutlet weak var loginOutButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    var categories = [Category]()
    var selectedCategory: Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    var weatherManager =  LocationManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //startupdatinglocation is for continuous
        
        
        
        weatherManager.delegate = self
        
        setupCollectionView()
        setupInitialAnonymousUser()
        
        
        

        
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
//
//        if Auth.auth().currentUser == nil {
//            Auth.auth().signInAnonymously { (result, error) in
//                if let error = error {
//                    Auth.auth().handleFireAuthError(error: error, vc: self)
//                    debugPrint(error)
//                }
//            }
//        }
        
        
    }
//
    
//
//
//    func fetchDocument() {
//        let docRef = db.coll
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCategoriesListener()
        locationManager.requestLocation()
        if let user = Auth.auth().currentUser , !user.isAnonymous {
            // We are logged in
            if let loginOutButton = loginOutButton {
                loginOutButton.title = "Logout"
            }
            if let favoriteBtn = favoriteBtn {
                favoriteBtn.isEnabled = true
            }
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        } else {
            loginOutButton.title = "Login"
            favoriteBtn.isEnabled = false
        }
    }
    
    func setupCollectionView() {
        
        if let collectionView = collectionView {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        } else {return}
    }
    
    func setupInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        guard let collectionView = collectionView else {return}
        collectionView.reloadData()
    }
    
    func setCategoriesListener() {
        listener = db.categories.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
//MARK: - Bar Button Items
    
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.toFavorites, sender: self)
    }
    
    
    @IBAction func searchClicked(_ sender: Any) {
        searchBar.alpha = abs(searchBar.alpha-1.0)
        
    }
    
    
    @IBAction func userClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.toUserInfoVC, sender: self)
        locationManager.requestLocation()
    }
    
    
    
    fileprivate func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    self.presentLoginController()
                }
            } catch {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
        }
        
        

    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
        guard let collectionView = collectionView else {return}
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }

    func onDocumentModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            // Item changed, but remained in the same position
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)

            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }

    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(categories.count)
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = width-40
        let cellHeight = width/2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.toListingsVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toListingsVC {
            if let destination = segue.destination as? ListingsVC {
                destination.category = selectedCategory
            }
        } else if segue.identifier == Segues.toFavorites {
            if let destination = segue.destination as? ListingsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
            }
        }
    }
}

func updateUserLocationData(city: String) {
    print("View controller city is \(city)")
    guard let authUser = Auth.auth().currentUser else {
        return
    }
    var user = User.init(id: "", email: UserService.getEmail(), username: UserService.getUsername(), city: city)
    let sameUserRef : DocumentReference!
    sameUserRef = Firestore.firestore().collection("users").document(authUser.uid)
    user.id = authUser.uid


    let data = User.modelToData(user: user)
    sameUserRef.setData(data, merge: true) { (error) in

        if error != nil {
//            simpleAlert(title: "Error", msg: "Unable to upload Firestore document.")
            return
        }

    }
}

extension ViewController: LocationManagerDelegate {
    func didUpdateWeather(_ weatherManager: LocationManager, weather: LocationModel) {
        DispatchQueue.main.async {
            
            updateUserLocationData(city: weather.cityName)
            print("did update weather")
            UserService.user.city = weather.cityName
            UserService.user.country = weather.countryName
            UserService.user.lat = weather.latitude
            UserService.user.lon = weather.longitude
            
        }
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
        print("did fail with error")
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchLocation(latitude: lat, longitude: lon)
            print("did fetch weather")
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
