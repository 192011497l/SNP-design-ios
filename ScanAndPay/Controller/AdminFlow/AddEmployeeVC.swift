//
//  AddEmployeeVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

import UIKit

class AddEmployeeVC: BasicVC {

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var addButton : UIButton!
    
    @IBOutlet weak var nameTF : UITextField!
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var ageTF : UITextField!
    @IBOutlet weak var mobileTF : UITextField!
    @IBOutlet weak var roleTF : UITextField!
    @IBOutlet weak var qualificationTF : UITextField!
    @IBOutlet weak var experienceTF : UITextField!
    @IBOutlet weak var addressTF : UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)

        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    
    @objc func addButtonAction(){
        
        if nameTF.text?.isEmpty == true || emailTF.text?.isEmpty == true || ageTF.text?.isEmpty == true || mobileTF.text?.isEmpty == true || roleTF.text?.isEmpty == true || qualificationTF.text?.isEmpty == true || addressTF.text?.isEmpty == true {
            showAlert(title: "All Field is Required", message: "Please fill all the details", okActionHandler: {})
        }else{
            postAPI()
        }
      
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
   
}
extension AddEmployeeVC{
    
    func postAPI(){
        
        let formData = ["name":"\(nameTF.text ?? "")",
                   "email":"\(emailTF.text ?? "")",
                   "age":"\(ageTF.text ?? "")",
                   "mobile_no":"\(mobileTF.text ?? "")",
                    "role":"\(roleTF.text ?? "")",
                    "qualification":"\(qualificationTF.text ?? "")",
                    "experience":"\(experienceTF.text ?? "")",
                    "address":"\(addressTF.text ?? "")",
                    "status":"active"]
        
        let apiURL = APIList().urlString(url:.AddEmpAPI)
        print(apiURL)
           APIHandler().postAPIValues(type: AddEmployeeModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
               switch result {
               case .success(let data):
                   DispatchQueue.main.async { [self] in
                       showAlert(title: "Success", message: data.message, okActionHandler: {
                           let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListOfEmployeeVC") as! ListOfEmployeeVC
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
