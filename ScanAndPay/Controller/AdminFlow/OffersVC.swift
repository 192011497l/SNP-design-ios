//
//  OffersVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

import UIKit

class OffersVC: BasicVC {
    
    @IBOutlet weak var offerTableView: UITableView!{
        didSet{
            offerTableView.delegate = self
            offerTableView.dataSource = self
        }
    }
    @IBOutlet weak var addOfferButton : UIButton!
    @IBOutlet weak var backButton : UIButton!
    var backButtonConnection : Bool = false
    
    var OfferList : OfferListModel!
    var filteredOfferListData: [OfferListData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if backButtonConnection{
            backButton.isHidden = false
        }
        DispatchQueue.main.async{ [self] in
            getApi()
            if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin"{
                addOfferButton.isHidden = false
            }else{
                addOfferButton.isHidden = true
            }
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        addOfferButton.addTarget(self, action: #selector(addOfferButtonAction), for: .touchUpInside)
        
        let registerCell = UINib(nibName: "OffersTableViewCell", bundle: nil)
        offerTableView.register(registerCell, forCellReuseIdentifier: "OffersTableViewCell")
            
        }
    }
    
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addOfferButtonAction(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOfferDetailsVC") as! AddOfferDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func removeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let idNumber = filteredOfferListData[index].id
        self.showAlert(title: "Remove", message: filteredOfferListData[index].offerName, okActionHandler: {
            self.postAPI(IdNumber: idNumber)
        }, cancelActionHandler: {})
       
        
        offerTableView.reloadData()
    }

    


}
extension OffersVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredOfferListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = offerTableView.dequeueReusableCell(withIdentifier: "OffersTableViewCell") as! OffersTableViewCell
       let ListData = filteredOfferListData
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin"{
            cell.removeButton.isHidden = false
        }else{
            cell.removeButton.isHidden = true
        }
       cell.offersLabel.text = ListData[indexPath.row].offerName
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OffersDetailsVC") as! OffersDetailsVC
        vc.offerID = filteredOfferListData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.alpha = 0
           UIView.animate(withDuration: 1, delay: 0.3 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }

    
}
extension OffersVC{
    
    func getApi(){

        APIHandler().getAPIValues(type: OfferListModel.self, apiUrl: APIList().urlString(url:.OfferListAPI), method: "GET") { Result in
           switch Result {
           case.success(let data):
               DispatchQueue.main.async { [self] in
              
                   self.OfferList = data
               
                   self.filteredOfferListData = data.data
                
                   self.offerTableView.reloadData()
                }
            case .failure(let error):
               DispatchQueue.main.async { [self] in
                print("error ---> \(error)")
               self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})}
           }
        }
   }
    func postAPI(IdNumber : String){
        
        let formData = ["id":"\(IdNumber)"]
        let apiURL = APIList().urlString(url:.RemoveOfferAPI)
                        print(apiURL)
                           APIHandler().postAPIValues(type: AddOfferModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                               switch result {
                               case .success(let data):
                                   DispatchQueue.main.async { [self] in
                                       showAlert(title: "Success", message: data.message, okActionHandler: {
                                           self.getApi()
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
