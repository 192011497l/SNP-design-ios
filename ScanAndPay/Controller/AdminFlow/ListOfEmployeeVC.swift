//
//  ListOfEmployeeVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

import UIKit

class ListOfEmployeeVC: BasicVC {

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
    var employeeList : EmployeeListModel!
    var filteredEmployeeListData: [EmployeeListData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
        let registerCell = UINib(nibName: "ListOfEmployeeTableViewCell", bundle: nil)
        listOfEmployeeTableView.register(registerCell, forCellReuseIdentifier: "ListOfEmployeeTableViewCell")
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        addOfferButton.addTarget(self, action: #selector(addOfferButtonAction), for: .touchUpInside)
        
    }
    

    @objc func addOfferButtonAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEmployeeVC") as! AddEmployeeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func removeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let idNumber = filteredEmployeeListData[index].id
        self.showAlert(title: "Remove", message: filteredEmployeeListData[index].name, okActionHandler: {
            self.postAPI(IdNumber: idNumber)
        }, cancelActionHandler: {})
       
        
       
    }
   
}
extension ListOfEmployeeVC: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                filteredEmployeeListData = employeeList?.data ?? []
            } else {
                filteredEmployeeListData = employeeList?.data.filter { $0.name.lowercased().contains(searchText.lowercased()) } ?? []
            }
            listOfEmployeeTableView.reloadData()
        }
    
}

extension ListOfEmployeeVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredEmployeeListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfEmployeeTableView.dequeueReusableCell(withIdentifier: "ListOfEmployeeTableViewCell") as! ListOfEmployeeTableViewCell
        let ListData = filteredEmployeeListData
        cell.nameLabel.text = ListData[indexPath.row].name
        cell.ageLabel.text = ListData[indexPath.row].age
       cell.mobileLabel.text = ListData[indexPath.row].mobileNo
        cell.roleLabel.text = ListData[indexPath.row].role
        cell.removeButton.setTitle(ListData[indexPath.row].status, for: .normal)
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeDetailsVC") as! EmployeeDetailsVC
        vc.employeeID = filteredEmployeeListData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           // Initial state for animation
           cell.alpha = 0
           UIView.animate(withDuration: 1, delay: 0.3 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }
}
extension ListOfEmployeeVC{
    
    func getApi(){
        
        APIHandler().getAPIValues(type: EmployeeListModel.self, apiUrl: APIList().urlString(url:.EmpListAPI), method: "GET") { Result in
            switch Result {
            case.success(let data):
                DispatchQueue.main.async { [self] in
                self.employeeList = data
                    
                    self.filteredEmployeeListData = data.data
                    
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
