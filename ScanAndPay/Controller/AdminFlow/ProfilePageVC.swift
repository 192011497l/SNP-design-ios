//
//  ProfilePageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 08/01/24.
//

import UIKit

class ProfilePageVC: BasicVC {

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var editButton : UIButton!
    
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var mobileNoLabel: UITextField!
    @IBOutlet weak var shopNameTextfield: UITextField!
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    var profileID : String = UserDefaultsManager.shared.getValue(forKey: "UserID")
    var profileDetails: [ProfileData]?
    var UserProfileDetails: [UserProfileData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            shopNameLabel.isHidden = false
            shopNameTextfield.isHidden = false
        }else{
            shopNameLabel.isHidden = true
            shopNameTextfield.isHidden = true
        }
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        getProfile(profileID: profileID)
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{ [self] in
            getProfile(profileID: profileID)
        }
    }
    
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func editButtonAction(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfilePageVC") as! EditProfilePageVC
        vc.profileEditable = profileDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getProfile(profileID: String) {
        
        let formData = ["username":profileID]
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            
            let apiURL = APIList().urlString(url:.ProfileApi)
            print(apiURL)
               APIHandler().postAPIValues(type: ProfileModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                   switch result {
                   case .success(let data):
                       DispatchQueue.main.async { [self] in
                     
                           profileDetails = data.data
                               userNameLabel.text = profileDetails?.first?.username
                               emailLabel.text = profileDetails?.first?.email
                               mobileNoLabel.text = "\(profileDetails?.first?.mobileNo ?? "")"
                               shopNameTextfield.text = profileDetails?.first?.shopName
                               
                           }
                     
                       case .failure(let error):
                       DispatchQueue.main.async {
                           print("error ---> \(error)")
                           self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                       }
                   }
               }
        }else{
            
            let apiURL = APIList().urlString(url:.UserProfileApi)
            print(apiURL)
               APIHandler().postAPIValues(type: UserProfileModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                   switch result {
                   case .success(let data):
                       DispatchQueue.main.async { [self] in
                     
                           UserProfileDetails = data.data
                               userNameLabel.text = UserProfileDetails?.first?.username
                               emailLabel.text = UserProfileDetails?.first?.email
                               mobileNoLabel.text = "\(UserProfileDetails?.first?.mobileNo ?? "")"
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

