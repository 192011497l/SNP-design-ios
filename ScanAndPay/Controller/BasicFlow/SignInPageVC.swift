//
//  SignInPageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 02/01/24.
//

import UIKit

class SignInPageVC: BasicVC {

    @IBOutlet weak var backButton : UIButton!
    
    @IBOutlet weak var userNameTF : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpPageVC") as! SignUpPageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signInButton(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarVC2") as! TabBarVC2
//        self.navigationController?.pushViewController(vc, animated: true)
        if userNameTF.text?.isEmpty == true || passwordTF.text?.isEmpty == true   {
                showAlert(title: "All Field is Required", message: "Please fill all the details", okActionHandler: {})
            }else{
                postAPI()
            }
          
        }
    func postAPI(){
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            let formData = ["username":"\(userNameTF.text ?? "")",
                            "password":"\(passwordTF.text ?? "")"]
            
            let apiURL = APIList().urlString(url:.LoginApi)
            print(apiURL)
            APIHandler().postAPIValues(type: LoginModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        if data.status{
                            UserDefaultsManager.shared.setValue("\(userNameTF.text ?? "")", forKey: "UserID")
                            showAlert(title: "Success", message: data.message, okActionHandler: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                        else{
                            showAlert(title: "Error", message: data.message, okActionHandler: {})
                        }
                        
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
                            "password":"\(passwordTF.text ?? "")"]
            
            let apiURL = APIList().urlString(url:.UserloginApi)
            print(apiURL)
            APIHandler().postAPIValues(type: LoginModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        if data.status{
                            UserDefaultsManager.shared.setValue("\(userNameTF.text ?? "")", forKey: "UserID")
                            showAlert(title: "Success", message: data.message, okActionHandler: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerHomePageVC") as! CustomerHomePageVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                        else{
                            showAlert(title: "Error", message: data.message, okActionHandler: {})
                        }
                        
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
    

