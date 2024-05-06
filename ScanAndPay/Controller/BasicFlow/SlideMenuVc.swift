//
//  SlideMenuVc.swift
//  ScanAndPay
//
//  Created by SAIL on 08/01/24.
//


import UIKit


protocol SlideMenuProto {
    
    func onSideMenu( menuNo : Int)
}


class SlideMenuVc: UIViewController {
    
    @IBOutlet weak var bglayoutView: UIView!
    
    
    @IBOutlet weak var slideView: UIView!
    
    @IBOutlet weak var historyDetailsLabel: UILabel!
    
    @IBOutlet weak var historyImage: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var sideDelegate : SlideMenuProto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            historyDetailsLabel.text = "History Details"
            historyImage.image = UIImage(named: "bill")
        }else{
            historyDetailsLabel.text = "Your Activity"
            historyImage.image = UIImage(named: "yourActivityImage")
        }
       
        
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        if touch?.view == self.bglayoutView {
//            self.dismiss(animated: false, completion: nil)
//        }
//    }
    @IBAction func onHome(_ sender: UIButton) {
        sideDelegate.onSideMenu(menuNo: 1)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onProfile(_ sender: UIButton) {
        sideDelegate.onSideMenu(menuNo: 2)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func onGraph(_ sender: UIButton) {
        sideDelegate.onSideMenu(menuNo: 3)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func onLogout(_ sender: UIButton) {
        sideDelegate.onSideMenu(menuNo: 4)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
   
}
