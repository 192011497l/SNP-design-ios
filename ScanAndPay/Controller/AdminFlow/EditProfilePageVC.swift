//
//  EditProfilePageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 08/01/24.
//

import UIKit

class EditProfilePageVC: BasicVC {

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var editButton : UIButton!
    
    @IBOutlet weak var UserNameTF : UITextField!
    @IBOutlet weak var EmailTF : UITextField!
    @IBOutlet weak var MobileNOTF : UITextField!
    @IBOutlet weak var ShopNameTF : UITextField!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    var profileEditable: [ProfileData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            shopNameLabel.isHidden = false
            ShopNameTF.isHidden = false
        }else{
            shopNameLabel.isHidden = true
            ShopNameTF.isHidden = true
        }
        UserNameTF.text = UserDefaultsManager.shared.getValue(forKey: "UserID")
        UserNameTF.isUserInteractionEnabled = false
        EmailTF.text = profileEditable?.first?.email
        MobileNOTF.text = profileEditable?.first?.mobileNo
        ShopNameTF.text = profileEditable?.first?.shopName
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
    }
   

    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func editButtonAction(){
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            if UserNameTF.text?.isEmpty == true || EmailTF.text?.isEmpty == true || MobileNOTF.text?.isEmpty == true || ShopNameTF.text?.isEmpty == true {
                showAlert(title: "All Field is Required", message: "Please fill all the details", okActionHandler: {})
            }else{
                posAPI()
            }
        }else{
            if UserNameTF.text?.isEmpty == true || EmailTF.text?.isEmpty == true || MobileNOTF.text?.isEmpty == true {
                showAlert(title: "All Field is Required", message: "Please fill all the details", okActionHandler: {})
            }else{
                posAPI()
            }
        }
       
    }
}
extension EditProfilePageVC{
    
    func posAPI(){
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            let formData = ["username":"\(UserNameTF.text ?? "")",
                            "email":"\(EmailTF.text ?? "")",
                            "mobile_no":"\(MobileNOTF.text ?? "")",
                            "shop_name":"\(ShopNameTF.text ?? "")"]
            
            let apiURL = APIList().urlString(url:.EditProfileApi)
            APIHandler().postAPIValues(type: EditProfileModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        showAlert(title: "Success", message: data.message, okActionHandler: {
                            self.navigationController?.popViewController(animated: true)
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
            let formData = ["username":"\(UserNameTF.text ?? "")",
                            "email":"\(EmailTF.text ?? "")",
                            "mobile_no":"\(MobileNOTF.text ?? "")"]
            
            let apiURL = APIList().urlString(url:.UserEditProfileApi)
            APIHandler().postAPIValues(type: EditProfileModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        showAlert(title: "Success", message: data.message, okActionHandler: {
                            self.navigationController?.popViewController(animated: true)
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
