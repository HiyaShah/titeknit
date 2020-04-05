//
//  DeliverQuestionVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/4/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Firebase

class DeliverQuestionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func yesPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func xPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
