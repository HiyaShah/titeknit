//
//  VolunteerVC.swift
//  CovidRelief
//
//  Created by Hiya Shah on 4/4/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class VolunteerVC: UIViewController {

    
    @IBOutlet weak var CircularProgress: CircularProgressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupLevelProgress()
        }

    func setupLevelProgress() {
//        let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
//        cp.trackColor = UIColor.white
//        cp.progressColor = UIColor(red: 252.0/255.0, green: 141.0/255.0, blue: 165.0/255.0, alpha: 1.0)
//        cp.tag = 101
//        self.view.addSubview(cp)
//        cp.center = self.view.center
//
//        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
        
        CircularProgress.trackColor = #colorLiteral(red: 0.7529411765, green: 0.6, blue: 0.9137254902, alpha: 0.3510809075)
        CircularProgress.progressColor = #colorLiteral(red: 0.7529411765, green: 0.6, blue: 0.9137254902, alpha: 1)
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.3)
    }
        
    @objc func animateProgress() {
            let cP = self.view.viewWithTag(101) as! CircularProgressView
            cP.setProgressWithAnimation(duration: 1.0, value: 0.7)
            
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }


}
