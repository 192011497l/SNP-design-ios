//
//  LoginPageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 02/01/24.
//

import UIKit

class LoginPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
   

    @IBAction func adminButton(_ sender: Any) {
        UserDefaultsManager.shared.setValue("Admin", forKey: "UserProfile")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SignInPageVC") as! SignInPageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func customerButton(_ sender: Any) {
        UserDefaultsManager.shared.setValue("Customer", forKey: "UserProfile")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SignInPageVC") as! SignInPageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
