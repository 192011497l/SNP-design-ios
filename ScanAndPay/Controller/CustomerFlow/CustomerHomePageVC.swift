//
//  CustomerHomePageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 09/01/24.
//

import UIKit

class CustomerHomePageVC: BasicVC, SlideMenuProto {

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var addOfferButton : UIButton!
    @IBOutlet weak var listOfEmployeeTableView: UITableView!{
        didSet{
            listOfEmployeeTableView.delegate = self
            listOfEmployeeTableView.dataSource = self
        }
    }
    @IBOutlet weak var searchBarOutlet: UISearchBar! {
        didSet {
            searchBarOutlet.delegate = self
        }
    }
    var shopList : ShopModel!
    var filteredshopListData: [ShopData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
        let registerCell = UINib(nibName: "CustomerHomeCell", bundle: nil)
        listOfEmployeeTableView.register(registerCell, forCellReuseIdentifier: "CustomerHomeCell")
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        addOfferButton.addTarget(self, action: #selector(addOfferButtonAction), for: .touchUpInside)
        
    }
    func onSideMenu(menuNo: Int) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if menuNo == 1 {

        }
        else if menuNo == 2 {
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfilePageVC") as! ProfilePageVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuNo == 3 {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
            vc.pageType = "HistoryPage"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuNo == 4 {
            
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginPageVC") as! LoginPageVC
                self.navigationController?.pushViewController(vc, animated: true)
        }else {
            print("LOGOUT MUST BE DONE")
        }
        
    }

    @objc func addOfferButtonAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePageVC") as! ProfilePageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func backButtonAction(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVc") as! SlideMenuVc
        vc.sideDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
   
}
extension CustomerHomePageVC: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                filteredshopListData = shopList?.data ?? []
            } else {
                filteredshopListData = shopList?.data.filter { $0.shopName.lowercased().contains(searchText.lowercased()) } ?? []
            }
            listOfEmployeeTableView.reloadData()
        }
    
}

extension CustomerHomePageVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredshopListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfEmployeeTableView.dequeueReusableCell(withIdentifier: "CustomerHomeCell") as! CustomerHomeCell
        let ListData = filteredshopListData
        cell.addressLabel.text = ListData[indexPath.row].shopAddress
        cell.shopNameLabel.text = ListData[indexPath.row].shopName
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC2") as! TabBarVC2
//        vc.backButtonBool = true
//        vc.employeeID = filteredshopListData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           // Initial state for animation
           cell.alpha = 0
           UIView.animate(withDuration: 1, delay: 0.1 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }
}
extension CustomerHomePageVC{
    
    func getApi(){
        
        APIHandler().getAPIValues(type: ShopModel.self, apiUrl: APIList().urlString(url:.shopsApi), method: "GET") { Result in
            switch Result {
            case.success(let data):
                DispatchQueue.main.async { [self] in
                self.shopList = data
                    
                    self.filteredshopListData = data.data
                    
                self.listOfEmployeeTableView.reloadData()
                }
            case .failure(let error):
                print("error ---> \(error)")
                self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
            }
        }
    }
    func postAPI(IdNumber : String){
        
        let formData = ["id":"\(IdNumber)"]
        let apiURL = APIList().urlString(url:.ActiveAPI)
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
