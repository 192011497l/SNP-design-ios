//
//  HistoryDetailsVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

import UIKit

class HistoryDetailsVC: BasicVC {
    
 
    
    @IBOutlet weak var historyDetailsTableView: UITableView!{
        didSet{
            historyDetailsTableView.delegate = self
            historyDetailsTableView.dataSource = self
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusResultLabel: UILabel!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var paymentIDlabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    @IBOutlet weak var billStatusLabel: UILabel!
    @IBOutlet weak var totalItemslabel: UILabel!
    @IBOutlet weak var totalQtyLabel: UILabel!
    @IBOutlet weak var overallTotalLabel: UILabel!
    @IBOutlet weak var completedButton : UIButton!
    
    var pageType = ""
    var paymentID : String = ""
    var totalAmount : Int = 0
    var totalQty : Int = 0
    var historyDetails: [ViewHistoryData] = []
    var billListDatas: [ViewBillData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin"{
            if pageType == "HistoryPage"{
                completedButton.isHidden = true
                statusResultLabel.isHidden = false
            }else {
                completedButton.isHidden = false
                statusResultLabel.isHidden = true
            }
        }else{
            completedButton.isHidden = true
            statusResultLabel.isHidden = false
        }
           
        gethistoryDetails(paymentID: paymentID)
        let registerCell = UINib(nibName: "HistoryDetailsTableViewCell", bundle: nil)
        historyDetailsTableView.register(registerCell, forCellReuseIdentifier: "HistoryDetailsTableViewCell")
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        completedButton.addTarget(self, action: #selector(completedButtonAction), for: .touchUpInside)
    }
    
    @objc func completedButtonAction(){
        completeApi (paymentID: paymentID)
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    func gethistoryDetails(paymentID: String) {
        if pageType == "HistoryPage" {
            
            let formData = ["payment_id":paymentID]
            
            let apiURL = APIList().urlString(url:.ViewHistoryApi)
            print(apiURL)
            APIHandler().postAPIValues(type: ViewHistoryModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        historyDetails = data.cart_data
                        paymentIDlabel.text = "Payment ID : \(data.payment_id)"
                        paymentDateLabel.text = "Payment Date : \(data.payment_date)"
                        billStatusLabel.text = "Status : \(data.bill_status)"
                        titleLabel.text = "History Details"
                        historyDetailsTableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("error ---> \(error)")
                        self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                    }
                }
            }
        }else {
            let formData = ["payment_id":paymentID]
            
            let apiURL = APIList().urlString(url:.ViewBillListApi)
               APIHandler().postAPIValues(type: ViewBillModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                   switch result {
                   case .success(let data):
                       DispatchQueue.main.async { [self] in
                           billListDatas = data.cartData
                           paymentIDlabel.text = "Payment ID : \(data.paymentID)"
                           paymentDateLabel.text = "Payment Date : \(data.paymentDate)"
                           billStatusLabel.text = "Status : \(data.billStatus)"
                           titleLabel.text = "Bill Details"
                           historyDetailsTableView.reloadData()
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
    func completeApi (paymentID: String){
      
            
            let formData = ["payment_id":paymentID]
            
            let apiURL = APIList().urlString(url:.acceptApi)
            print(apiURL)
            APIHandler().postAPIValues(type: AddOfferModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        showAlert(title: "Success", message: data.message, okActionHandler: {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
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

extension HistoryDetailsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageType == "HistoryPage"{
            historyDetails.count
        }else {
            billListDatas.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyDetailsTableView.dequeueReusableCell(withIdentifier: "HistoryDetailsTableViewCell") as! HistoryDetailsTableViewCell
        cell.sNoLabel.text = "\(indexPath.row + 1)."
        if pageType == "HistoryPage"{
           
            cell.nameLabel.text = historyDetails[indexPath.row].name
            cell.priceLabel.text = historyDetails[indexPath.row].price
            cell.QtyLabel.text = historyDetails[indexPath.row].quantity
            cell.totalAmountLabel.text = "₹.\(historyDetails[indexPath.row].totalPrice)"
            totalAmount = totalAmount + (Int(historyDetails[indexPath.row].totalPrice ) ?? 0)
            totalQty = totalQty + (Int(historyDetails[indexPath.row].quantity ) ?? 0)
            overallTotalLabel.text = "Total : ₹.\(totalAmount)"
            totalQtyLabel.text = "Total Qty: \(totalQty)"
            totalItemslabel.text = "Items Count : \(indexPath.row + 1)"
            print("totalAmount : \(totalAmount)")
        }else {
           
            cell.nameLabel.text = billListDatas[indexPath.row].name
            cell.priceLabel.text = billListDatas[indexPath.row].price
            cell.QtyLabel.text = billListDatas[indexPath.row].quantity
            cell.totalAmountLabel.text = "₹.\(billListDatas[indexPath.row].totalPrice)"
            totalAmount = totalAmount + (Int(billListDatas[indexPath.row].totalPrice ) ?? 0)
            totalQty = totalQty + (Int(billListDatas[indexPath.row].quantity ) ?? 0)
            overallTotalLabel.text = "Total : ₹.\(totalAmount)"
            totalQtyLabel.text = "Total Qty: \(totalQty)"
            totalItemslabel.text = "Items Count : \(indexPath.row + 1)"
            print("totalAmount : \(totalAmount)")
        }
       
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailsVC") as! HistoryDetailsVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           // Initial state for animation
           cell.alpha = 0

           // Animation when the cell is about to be displayed with delay
           UIView.animate(withDuration: 1, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }
    
}
