//
//  TypesSupported.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/3/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

protocol TypeSupportedCellDelegate : class {
    func typeSelected(wish: Wish)
}


class TypesSupported: UITableViewCell {

    
    @IBOutlet weak var checkmarkCircle: UIButton!
    
    
    @IBOutlet weak var typeLbl: UILabel!
    
    weak var delegate : TypeSupportedCellDelegate?
    private var wish: Wish!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(wish: Wish, delegate: TypeSupportedCellDelegate) {
        self.wish = wish
        self.delegate = delegate
        
        typeLbl.text = wish.type
        
        if UserService.wishlist.contains(wish) {
            if #available(iOS 13.0, *) {
                checkmarkCircle.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 13.0, *) {
                checkmarkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
            
    }
    
    @IBAction func checkMarkPressed(_ sender: Any) {

        delegate?.typeSelected(wish: wish)
    }
    
    
}
