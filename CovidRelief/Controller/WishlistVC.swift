//
//  WishlistVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/2/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class WishlistVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var selectionLbl: UILabel!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        let sortedListingTypesSupported = CategoryInformation.listingTypesSupported.sorted { $0.self < $1.self }
        CategoryInformation.listingTypesSupported = sortedListingTypesSupported

    }
    

    @IBAction func saveChangesClicked(_ sender: Any) {
        if UserService.isGuest {
            self.simpleAlert(title: "Hello Neighbor!", msg: "Please create a free account to set your wishlist and take advantage of all our features.")
            return
        }
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CategoryInformation.listingTypesSupported.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CategoryInformation.listingTypesSupported[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionLbl.text = CategoryInformation.listingTypesSupported[row]
    }
}
