//
//  EmployeeDetailsVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

// EmployeeDetailsVC.swift

import UIKit

class EmployeeDetailsVC: BasicVC {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var employeeID: String = ""
    var employeeDetails: [EmployeeDetailsData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        getEmployeeDetails(employeeID: employeeID)
    }

    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    
    func getEmployeeDetails(employeeID: String) {
        
        let formData = ["id":employeeID]
        
        let apiURL = APIList().urlString(url:.EmployeeDetailsAPI)
        print(apiURL)
           APIHandler().postAPIValues(type: EmployeeDetailsModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
               switch result {
               case .success(let data):
                   self.employeeDetails = data.data
                       DispatchQueue.main.async { [self] in
                           nameLabel.text = employeeDetails?.first?.name
                           emailLabel.text = employeeDetails?.first?.email
                           mobileNoLabel.text = "\(employeeDetails?.first?.mobileNo ?? 0)"
                           ageLabel.text = "\(employeeDetails?.first?.age ?? 0)"
                           qualificationLabel.text = employeeDetails?.first?.qualification
                           roleLabel.text = employeeDetails?.first?.role
                           experienceLabel.text = employeeDetails?.first?.experience
                           addressLabel.text = employeeDetails?.first?.address
                           
                           
                           
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



