//
//  OffersDetailsVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

import UIKit

class OffersDetailsVC: BasicVC {

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var offerDetailsLabel: UILabel!
    
    
    var offerID: String = ""
    var offerDetails: [OfferDetailsData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        getOfferDetails(offerID: offerID)
    }

    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    
    func getOfferDetails(offerID: String) {
        
        let formData = ["id":offerID]
        
        let apiURL = APIList().urlString(url:.OfferDetailsAPI)
        print(apiURL)
           APIHandler().postAPIValues(type: OfferDetailsModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
               switch result {
               case .success(let data):
                   
                       DispatchQueue.main.async { [self] in
                           self.offerDetails = data.data
                           offerNameLabel.text = offerDetails?.first?.offerName
                           expiryDateLabel.text = offerDetails?.first?.expiryDate
                           offerDetailsLabel.text = offerDetails?.first?.offerDetails
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



