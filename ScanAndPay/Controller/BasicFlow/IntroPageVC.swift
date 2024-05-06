//
//  IntroPageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 02/01/24.
//

import UIKit

class IntroPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
       
    }
    

    @IBAction func getStartedButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginPageVC") as! LoginPageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
