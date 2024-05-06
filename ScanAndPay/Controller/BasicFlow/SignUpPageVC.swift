//
//  SignUpPageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 02/01/24.
//

import UIKit

class SignUpPageVC: BasicVC {
    
    @IBOutlet weak var backButton : UIButton!
    
    @IBOutlet weak var userNameTF : UITextField!
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var mobileTF : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    @IBOutlet weak var confirmPasswordTF : UITextField!
    @IBOutlet weak var shopNameTF : UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            shopNameTF.isHidden = false
        }else{
            shopNameTF.isHidden = true
        }
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    @IBAction func signUpButton(_ sender: Any) {
        if userNameTF.text?.isEmpty == true || emailTF.text?.isEmpty == true ||  mobileTF.text?.isEmpty == true || passwordTF.text?.isEmpty == true || confirmPasswordTF.text?.isEmpty == true {
            showAlert(title: "All Field is Required", message: "Please fill all the details", okActionHandler: {})
        }else{
            postAPI()
        }
      
    }
    
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
        func postAPI(){
           
          if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
              let formData = ["username":"\(userNameTF.text ?? "")",
                         "email":"\(emailTF.text ?? "")",
                         "mobile_no":"\(mobileTF.text ?? "")",
                         "shop_name":"\(shopNameTF.text ?? "")",
                          "password":"\(passwordTF.text ?? "")",
                          "confirm_password":"\(confirmPasswordTF.text ?? "")"]
              
              let apiURL = APIList().urlString(url:.RegisterApi)
              print(apiURL)
                 APIHandler().postAPIValues(type: RegisterModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                     switch result {
                     case .success(let data):
                         DispatchQueue.main.async { [self] in
                             showAlert(title: "Success", message: data.message, okActionHandler: {
                                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInPageVC") as! SignInPageVC
                                 self.navigationController?.pushViewController(vc, animated: true)
                             })
                         }
                         case .failure(let error):
                         DispatchQueue.main.async {
                             print("error ---> \(error)")
                             self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                         }
                     }
                 }
          }else{
              let formData = ["username":"\(userNameTF.text ?? "")",
                         "email":"\(emailTF.text ?? "")",
                         "mobile_no":"\(mobileTF.text ?? "")",
                          "password":"\(passwordTF.text ?? "")",
                          "confirm_password":"\(confirmPasswordTF.text ?? "")"]
              
              let apiURL = APIList().urlString(url:.UserRegisterApi)
              print(apiURL)
                 APIHandler().postAPIValues(type: RegisterModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                     switch result {
                     case .success(let data):
                         DispatchQueue.main.async { [self] in
                             showAlert(title: "Success", message: data.message, okActionHandler: {
                                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInPageVC") as! SignInPageVC
                                 self.navigationController?.pushViewController(vc, animated: true)
                             })
                         }
                         case .failure(let error):
                         DispatchQueue.main.async {
                             print("error ---> \(error)")
                             self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                         }
                     }
                 }
          }

        }

    }
    
   

