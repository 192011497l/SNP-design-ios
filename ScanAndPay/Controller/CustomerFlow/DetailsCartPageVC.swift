//
//  DetailsCartPageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 02/02/24.
//

import UIKit
import Razorpay

class DetailsCartPageVC: BasicVC {
    
    @IBOutlet weak var historyDetailsTableView: UITableView!{
        didSet{
            historyDetailsTableView.delegate = self
            historyDetailsTableView.dataSource = self
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusResultLabel: UILabel!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var paymentIDlabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    @IBOutlet weak var billStatusLabel: UILabel!
    @IBOutlet weak var totalItemslabel: UILabel!
    @IBOutlet weak var totalQtyLabel: UILabel!
    @IBOutlet weak var overallTotalLabel: UILabel!
    
    let razorpayTestKey = "rzp_test_5rwYE521v89m4u"
    var razorpay: RazorpayCheckout!
    var pageType = ""
    var paymentID : String = ""
    var totalAmount : Int = 0
    var totalQty : Int = 0
    var filteredCartListData : [CartData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        razorpay = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
        getApi()
        let registerCell = UINib(nibName: "HistoryDetailsTableViewCell", bundle: nil)
        historyDetailsTableView.register(registerCell, forCellReuseIdentifier: "HistoryDetailsTableViewCell")
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(payButtonAction), for: .touchUpInside)
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func payButtonAction() {
        
        showPayConfirmationAlert()
    }
    internal func showPaymentForm(Amount : Int){
    
      let options: [String:Any] = [
            "amount": Amount * 100,
            "currency": "INR",
            "description": "",
            "order_id": "",
            "image": UIImage(named: "homePageImage") as Any,
            "name": "Scan And Pay",
            "timeout":120,
            "prefill": [
              "contact": "9876543210",
              "email": "scanandpay@gmail.com"
            ],
            "theme": [
              "color": "#1D4580"
            ]
          ]
        DispatchQueue.main.async{
            self.razorpay.open(options, displayController: self)
        }
    }
    func showPayConfirmationAlert() {
        showAlert(title: "Payment Confirmation", message: "Are you sure you want to proceed with payment?", okActionHandler: {
            DispatchQueue.main.async{
                self.showPaymentForm(Amount: self.totalAmount)
            } }, cancelActionHandler: {})
    }
    
    func makePayment() {
        let apiURL = APIList().urlString(url:.PaymentAPI)
        print(apiURL)
        APIHandler().getAPIValues(type: PaymentModel.self, apiUrl: apiURL, method: "GET") {  result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC2") as! TabBarVC2
//                vc.pageType = "BillPage"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error ---> \(error)")
                    self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                }
            }
        }
    }
    
    func  getApi(){
        
        APIHandler().getAPIValues(type: CartModel.self, apiUrl: APIList().urlString(url:.cartApi), method: "GET") { Result in
            DispatchQueue.main.async {
                switch Result {
                case.success(let data):
                    DispatchQueue.main.async { [self] in
                        self.filteredCartListData = data.cartDetails
                        self.historyDetailsTableView.reloadData()
                    }
                case .failure(let error):
                    print("error ---> \(error)")
                    self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                }
            }
        }
    }
        
}

extension DetailsCartPageVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            filteredCartListData.count
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyDetailsTableView.dequeueReusableCell(withIdentifier: "HistoryDetailsTableViewCell") as! HistoryDetailsTableViewCell
        cell.sNoLabel.text = "\(indexPath.row + 1)."
       
            cell.nameLabel.text = filteredCartListData[indexPath.row].name
            cell.priceLabel.text = "\(filteredCartListData[indexPath.row].price)"
            cell.QtyLabel.text = "\(filteredCartListData[indexPath.row].quantity)"
            cell.totalAmountLabel.text = "₹.\(filteredCartListData[indexPath.row].totalPrice)"
            totalAmount = totalAmount + (Int(filteredCartListData[indexPath.row].totalPrice ) )
            totalQty = totalQty + (Int(filteredCartListData[indexPath.row].quantity ) )
            overallTotalLabel.text = "Total : ₹.\(totalAmount)"
            totalQtyLabel.text = "Total Qty: \(totalQty)"
            totalItemslabel.text = "Items Count : \(indexPath.row + 1)"
            print("totalAmount : \(totalAmount)")
      
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
           cell.alpha = 0

           // Animation when the cell is about to be displayed with delay
           UIView.animate(withDuration: 1, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }
    
}
extension DetailsCartPageVC : RazorpayPaymentCompletionProtocol {
  func onPaymentError(_ code: Int32, description str: String) {
    print("error: ", code, str)

    showAlert(title: "Failure", message: str)
  }
  func onPaymentSuccess(_ payment_id: String) {
    print("success: ", payment_id)
      showAlert(title: "Success", message: "Payment Succeeded",okActionHandler: {
          self.makePayment()
      })
   }
    
}

