//
//  ListingDetailVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/4/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import FirebaseFirestore


class ListingDetailVC: UIViewController {

    @IBOutlet weak var usernameCityTxt: UILabel!
    
    @IBOutlet weak var listingNameTxt: UILabel!
    @IBOutlet weak var listingTypeTxt: UILabel!
    @IBOutlet weak var inStock: UILabel!
    
    
    @IBOutlet weak var listingImgView: UIImageView!
    
    @IBOutlet weak var listingDescriptionText: UILabel!
    
    @IBOutlet weak var requestBtn: RoundedButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var listing : Listing!
    var requests = [User]()
    var listener: ListenerRegistration!
    var db : Firestore!
    var isGiver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.RequestCellTableViewCell, bundle: nil), forCellReuseIdentifier: Identifiers.RequestCellTableViewCell)
        if let listing = listing {
        listingNameTxt.text = listing.name
            listingTypeTxt.text = listing.type
            if listing.stock > 0{
                inStock.text = "In Stock"
                    inStock.textColor = UIColor.green
            } else {
                inStock.text = "Currently Out Of Stock"
                inStock.textColor = UIColor.red
            }
            listingDescriptionText.text = listing.listingDescription
            usernameCityTxt.text = "kindly listed by \(listing.username) from \(listing.city)"
            
            if let url = URL(string: listing.imgUrl) {
                listingImgView.contentMode = .scaleAspectFill
                listingImgView.kf.setImage(with: url)
            }
            
            if UserService.isGuest || UserService.user.username == listing.username {
                requestBtn.isHidden = true

            }
        }
        db = Firestore.firestore()
        self.title = "Listing Details"
        
        setupQuery()
        
    }
    
    func setupQuery() {
        var ref: Query!
        
        ref = db.collection("listings").document(listing!.id).collection("requests")

        
        listener = ref.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let listing = Listing.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, user: UserService.user)
                case .modified:
                    self.onDocumentModified(change: change, user: UserService.user)
                case .removed:
                    self.onDocumentRemoved(change: change)
                @unknown default:
                    fatalError()
                }
            })
        })
    }
    

    @IBAction func requestItemClicked(_ sender: UIButton) {
        
        if let buttonTitle = sender.title(for: .normal) {
          if buttonTitle != "Delete Request"{
              let vc = DeliverQuestionVC()
              vc.modalTransitionStyle = .crossDissolve
              vc.modalPresentationStyle = .overCurrentContext
              present(vc, animated: true, completion: nil)
          }
        }
        requestMade()
        
    }
    
    func requestMade() {
        print("listing favorited")
        if UserService.isGuest {
            self.simpleAlert(title: "Hello Neighbor!", msg: "Please create a free account to favorite this account and take advantage of all our features.")
            return
        }
        ListingService.requestMade(listing: listing, user: UserService.user)
        guard let index = requests.firstIndex(of: UserService.user) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

extension ListingDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, user: User) {
            let newIndex = Int(change.newIndex)
            print(newIndex)
            requests.insert(user, at: newIndex)
            tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    
            print("document (listing) added")
            requestBtn.setTitle("Delete Request", for: .normal)
        }
        
        func onDocumentModified(change: DocumentChange, user: User) {
            print("document (listing) modifying")
            if change.oldIndex == change.newIndex {
                // Item changed, but remained in the same position
                let index = Int(change.newIndex)
                requests[index] = user
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            } else {
                // Item changed and changed position
                let oldIndex = Int(change.oldIndex)
                let newIndex = Int(change.newIndex)
                if oldIndex != newIndex {
                    requests.remove(at: oldIndex)
                    requests.insert(user, at: newIndex)
                    tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
                }
            }
        }
        
        func onDocumentRemoved(change: DocumentChange) {
            let oldIndex = Int(change.oldIndex)
            requests.remove(at: oldIndex)
            tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
            print("document (listing) removed")
            requestBtn.setTitle("Request Item", for: .normal)
            
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("listingscount is \(requests.count)")
        
        return requests.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RequestCellTableViewCell, for: indexPath) as? RequestCellTableViewCell {
            cell.configureCell(user: UserService.user, isGiver: isGiver)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}

