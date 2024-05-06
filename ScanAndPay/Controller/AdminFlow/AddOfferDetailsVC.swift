//
//  AddOfferDetailsVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

import UIKit

class AddOfferDetailsVC: BasicVC {

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var addButton : UIButton!
    
    @IBOutlet weak var OfferTF : UITextField!
    @IBOutlet weak var ExpiryDateTF : UITextField!
    @IBOutlet weak var OfferDetailsTF : UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)

        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    
    @objc func addButtonAction(){
        
        if OfferTF.text?.isEmpty == true || ExpiryDateTF.text?.isEmpty == true || OfferDetailsTF.text?.isEmpty == true {
            showAlert(title: "All Field is Required", message: "Please fill all the details", okActionHandler: {})
        }else{
            postAPI()
        }
      
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
   
}
extension AddOfferDetailsVC{
    
    func postAPI(){
        
        let formData = ["offer_name":"\(OfferTF.text ?? "")",
                   "expiry_date":"\(ExpiryDateTF.text ?? "")",
                        "offer_details":"\(OfferDetailsTF.text ?? "")"]
                  
                        let apiURL = APIList().urlString(url:.AddOfferAPI)
                        print(apiURL)
                           APIHandler().postAPIValues(type: AddOfferModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                               switch result {
                               case .success(let data):
                                   DispatchQueue.main.async { [self] in
                                       showAlert(title: "Success", message: data.message, okActionHandler: {
                                           let vc = self.storyboard?.instantiateViewController(withIdentifier: "OffersVC") as! OffersVC
                                           vc.backButtonConnection = true
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
