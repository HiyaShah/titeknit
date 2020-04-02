//
//  ListingsVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/23/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ListingsVC: UIViewController, ListingCellDelegate {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nearestBarBtn: UIBarButtonItem!
    @IBOutlet weak var newProductBarBtn: UIBarButtonItem!
    
    //variables
    var listings = [Listing]()
    var category: Category!
    var listener: ListenerRegistration!
    var db : Firestore!
    var showFavorites = false
    var showNearest = false
    var showWishlist = false
    var showGivings = false
    
    var selectedProduct : Listing?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.nearest = []
        UserService.givings = []
//        let newProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        //admin stuff
        if(showFavorites==true) {
            newProductBarBtn.isEnabled = false
            nearestBarBtn.isEnabled = false
        } else {
            newProductBarBtn.isEnabled = true
            nearestBarBtn.isEnabled = true
        }
        
        navigationItem.setRightBarButtonItems([newProductBarBtn, nearestBarBtn], animated: false)
        
        
        
        //client stuff
  
        db = Firestore.firestore()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ListingCell, bundle: nil), forCellReuseIdentifier: Identifiers.ListingCell)
        setupQuery()
        
        if(showGivings == true) {
            setupGivings()
        }
        
        
    }
    
    func setupGivings() {

        print(UserService.givings)
        UserService.givings = []
        var consToMinus = 0;
        for n in 0..<listings.count {
            if UserService.user.username == listings[n-consToMinus].username   {
                UserService.givingsSelected(listing: listings[n-consToMinus])
                print("adding in \(listings[n-consToMinus])")
            } else {
                print("document \(listings[n-consToMinus]) removed")
                listings.remove(at: n-consToMinus)
                tableView.deleteRows(at: [IndexPath(row: n-consToMinus, section: 0)], with: .left)
                
                consToMinus = consToMinus + 1
                
            }
        }
        print(UserService.nearest)
        nearestBarBtn.isEnabled = false
    }
    
    @IBAction func newProductClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToAddEditProducts, sender: self)

    }
//    @objc func newProduct() {
//        performSegue(withIdentifier: Segues.ToAddEditProducts, sender: self)
//    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProducts {
            print("segued to add edit vc")
            if let destination = segue.destination as? AddEditProductsVC {
                destination.adminSelectedCategory = category
                destination.listingToEdit = selectedProduct
            }
        }
    }

    
    func setupQuery() {
        var ref: Query!
        if showFavorites {
            ref = db.collection("users").document(UserService.user.id).collection("favorites")
        } else if showGivings {
            print("setupquerywithshowgivings")
            ref = db.collection("users").document(UserService.user.id).collection("givingListings")
        } else {
            ref = db.listings(category: category.id)
        }
        
        listener = ref.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let listing = Listing.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, listing: listing)
                case .modified:
                    self.onDocumentModified(change: change, listing: listing)
                case .removed:
                    self.onDocumentRemoved(change: change)
                @unknown default:
                    fatalError()
                }
            })
        })
    }

    
    func listingFavorited(listing: Listing) {
        print("listing favorited")
        if UserService.isGuest {
            self.simpleAlert(title: "Hello Neighbor!", msg: "Please create a free account to favorite this account and take advantage of all our features.")
            return
        }
        
        UserService.favoriteSelected(listing: listing)
        guard let index = listings.firstIndex(of: listing) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func listingNearest(listing: Listing) {
//        print("listing favorited")
//        if UserService.isGuest {
//            self.simpleAlert(title: "Hi friend!", msg: "This is a user only feature, please create a free user to take advantage of all our features.")
//            return
//        }
////        if(self.)
        print("listingNearestCalled")
        UserService.nearestSelected(listing: listing)
        guard let index = listings.firstIndex(of: listing) else { return }
        print(UserService.nearest)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func listingGiven(listing: Listing) {
        print("listingGivenCalled")
        UserService.givingsSelected(listing: listing)
        guard let index = listings.firstIndex(of: listing) else { return }
        print(UserService.givings)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    @IBAction func nearestBtnPressed(_ sender: Any) {
        print("shownearest = true")
        self.showNearest = true
        print(UserService.user.nearestZipsToHome)
        UserService.nearest = []
        var consToMinus = 1;
        for n in 1...listings.count {
            if UserService.user.nearestZipsToHome.contains(listings[n-consToMinus].getZip())   {
                UserService.nearestSelected(listing: listings[n-consToMinus])
                print("adding in \(listings[n-consToMinus])")
            } else {
                print("document \(listings[n-consToMinus]) removed")
                listings.remove(at: n-consToMinus)
                tableView.deleteRows(at: [IndexPath(row: n-consToMinus, section: 0)], with: .left)
                
                consToMinus = consToMinus + 1
                
            }
        }
        print(UserService.nearest)
        nearestBarBtn.isEnabled = false
    }
    
    

}

extension ListingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, listing: Listing) {
        let newIndex = Int(change.newIndex)
        listings.insert(listing, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
        print("document (listing) added")
    }
    
    func onDocumentModified(change: DocumentChange, listing: Listing) {
        if change.oldIndex == change.newIndex {
            // Item changed, but remained in the same position
            let index = Int(change.newIndex)
            listings[index] = listing
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            if oldIndex != newIndex {
                listings.remove(at: oldIndex)
                listings.insert(listing, at: newIndex)
                tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
            }
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        listings.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
        print("document (listing) removed")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserService.listingCount = listings.count
        return listings.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ListingCell, for: indexPath) as? ListingCell {
            cell.configureCell(listing: listings[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ProductDetailVC()
//        let selectedProduct = products[indexPath.row]
//        vc.product = selectedProduct
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
//        present(vc, animated: true, completion: nil)
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Editing product
//        selectedProduct = listings[indexPath.row]
//        performSegue(withIdentifier: Segues.ToAddEditProducts, sender: self)
//    }
}
