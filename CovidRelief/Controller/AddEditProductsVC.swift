//
//  AddEditProductsVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 3/28/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore


class AddEditProductsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    

    @IBOutlet weak var listingName: UITextField!
    
    @IBOutlet weak var stock: UITextField!
    
    @IBOutlet weak var listingDescription: UITextView!
    
    @IBOutlet weak var listingImgView: RoundedImageView!
    
    @IBOutlet weak var addBtn: RoundedButton!
    
    @IBOutlet weak var listingTypePickerView: UIPickerView!
    
    
    
    //variables
        var adminSelectedCategory : Category!
        var listingToEdit : Listing?
        
        var name = ""
        var stockCount = 0
        var listingdescription = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
            tap.numberOfTapsRequired = 1
            listingImgView.isUserInteractionEnabled = true
            listingImgView.clipsToBounds = true
            listingImgView.addGestureRecognizer(tap)
            
            if let listing = listingToEdit {
                listingName.text = listing.name
                listingDescription.text = listing.listingDescription
                addBtn.setTitle("Save Changes", for: .normal)
                
                if let url = URL(string: listing.imgUrl) {
                    listingImgView.contentMode = .scaleAspectFill
                    listingImgView.kf.setImage(with: url)
                }
            }
            
            listingTypePickerView.dataSource = self
            listingTypePickerView.delegate = self
        }
        
        @objc func imgTapped() {
            launchImgPicker()
        }
        
        @IBAction func addClicked(_ sender: Any) {
            uploadImageThenDocument()
            dismiss(animated: true, completion: nil)
        }
        
        func uploadImageThenDocument() {
            guard let image = listingImgView.image ,
            let name = listingName.text , name.isNotEmpty ,
            let description = listingDescription.text ,
            let stock = stock.text , stock.isNotEmpty
            else {
                    simpleAlert(title: "Missing Fields", msg: "Please fill out all required fields.")
                    return
            }
            
            self.name = name
            self.stockCount = Int(stock) ?? 0
            self.listingdescription = description
            
//            activityIndicator.startAnimating()
            
            // Step 1: Turn the image into Data
            guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
            
            // Step 2: Create an storage image reference -> A location in Firestorage for it to be stored.
            let imageRef = Storage.storage().reference().child("/listingImages/\(name).jpg")
            
            // Step 3: Set the meta data
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            // Step 4: Upload the data.
            imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
                
                if let error = error {
                    self.handleError(error: error, msg: "Unable to upload image.")
                    return
                }
                
                // Step 5: Once the image is uploaded, retrieve the download URL.
                imageRef.downloadURL(completion: { (url, error) in
                    
                    if let error = error {
                        self.handleError(error: error, msg: "Unable to download url")
                        return
                    }
                    
                    guard let url = url else { return }
                    print(url)
                    // Step 6: Upload new Product document to the Firestore products collection.
                    self.uploadDocument(url: url.absoluteString)
                })
            }
        }
        
        func uploadDocument(url: String) {
            print("upload doc clicked")
            var docRef : DocumentReference!
            var listing = Listing.init(name: name, id: "", category: adminSelectedCategory.id, price: 0.00, isActive: true, productDescription: listingdescription, imgUrl: url, stock: stockCount, username: UserService.user.username, email: UserService.user.email, city: UserService.user.city, zip: UserService.user.zipcode)
            print("made listing")
            if let listingToEdit = listingToEdit {
                // We are editing a product
                docRef = Firestore.firestore().collection("listings").document(listingToEdit.id)
                listing.id = listingToEdit.id
                print("edited listing")
            } else {
                // we are adding a new product
                docRef = Firestore.firestore().collection("listings").document()
                listing.id = docRef.documentID
                print("added listing")
            }
            
            let data = Listing.modelToData(listing: listing)
            docRef.setData(data, merge: true) { (error) in
                
                if let error = error {
                    self.handleError(error: error, msg: "Unable to upload Firestore document.")
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        func handleError(error: Error, msg: String) {
            debugPrint(error.localizedDescription)
            simpleAlert(title: "Error", msg: msg)
//            activityIndicator.stopAnimating()
        }
    }

    


    extension AddEditProductsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func launchImgPicker() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let image = info[.originalImage] as? UIImage else { return }
            listingImgView.contentMode = .scaleAspectFill
            listingImgView.image = image
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return adminSelectedCategory.listingNamesSupported.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return adminSelectedCategory.listingNamesSupported[row]
        }

    

}
