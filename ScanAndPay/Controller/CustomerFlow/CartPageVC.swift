//
//  CartPageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 02/02/24.
//

import UIKit


class CartPageVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var overAllTotalLabel : UILabel!
    @IBOutlet weak var checkOutButton : UIButton!
    @IBOutlet weak var cartTableView: UITableView!{
        didSet{
            cartTableView.delegate = self
            cartTableView.dataSource = self
        }
    }
    @IBOutlet weak var searchBarOutlet: UISearchBar! {
        didSet {
            searchBarOutlet.delegate = self
        }
    }
    var cartListData : [CartData] = []
    var filteredCartListData: [CartData] = []
    
    var totalValue : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
        let registerCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.register(registerCell, forCellReuseIdentifier: "CartTableViewCell")
//        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        checkOutButton.addTarget(self, action: #selector(checkOutButtonAction), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        getApi()
    }
    @objc func checkOutButtonAction(){
        
        if filteredCartListData.count == 0{
            showAlert(title: "Empty", message: "Add Items in Cart", okActionHandler: {})
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsCartPageVC") as! DetailsCartPageVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func removeButtonTapped(_ sender: UIButton) {
        let idToRemove = "\(filteredCartListData[sender.tag].sNo)"
        showAlert(title: "Remove Item", message: "Are you sure you want to remove this item?", okActionHandler: {
            self.postApi(idToRemove: idToRemove)
        }, cancelActionHandler: {})
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCartListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        let ListData = filteredCartListData
        cell.nameLabel.text = ListData[indexPath.row].name
        cell.quantityLabel.text = "No :\(ListData[indexPath.row].quantity)"
        cell.priceLabel.text = "₹.\(ListData[indexPath.row].price)"
        cell.totalPriceLabel.text = "Total : ₹.\(ListData[indexPath.row].totalPrice)"
        
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.15 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }
}


extension CartPageVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCartListData = cartListData
        } else {
            filteredCartListData = cartListData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        cartTableView.reloadData()
    }
}

extension CartPageVC{
    
    func getApi(){
        
            APIHandler().getAPIValues(type: CartModel.self, apiUrl: APIList().urlString(url:.cartApi), method: "GET") { Result in
                 DispatchQueue.main.async {
                     switch Result {
                     case.success(let data):
                         DispatchQueue.main.async { [self] in
                             self.cartListData = data.cartDetails
                             self.filteredCartListData = data.cartDetails
                             totalValue = filteredCartListData.reduce(0) { $0 + Int($1.totalPrice)}
                             print("OverAllTotal : ₹.\(totalValue)")
                             overAllTotalLabel.text = "OverAllTotal : ₹.\(totalValue)"
                             self.cartTableView.reloadData()
                         }
                     case .failure(let error):
                         print("error ---> \(error)")
                         self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                     }
                 }
             }
        }
    func postApi(idToRemove: String) {
        let formData = ["s_no": "\(idToRemove)"]
        let apiURL = APIList().urlString(url: .RemovecartAPI)
        print(apiURL)
        
        APIHandler().postAPIValues(type: AddOfferModel.self, apiUrl: apiURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    self.showAlert(title: "Success", message: data.message, okActionHandler: {self.getApi()})
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

    
    

