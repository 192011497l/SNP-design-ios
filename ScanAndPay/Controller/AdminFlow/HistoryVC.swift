//
//  HistoryVC.swift
//  ScanAndPay
//
//  Created by SAIL on 03/01/24.
//

import UIKit

class HistoryVC: BasicVC {

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var historyTableView: UITableView!{
        didSet{
            historyTableView.delegate = self
            historyTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    var historyListData : [HistoryListData] = []
    var billListDatas : [BillListData] = []
    var pageType = "HistoryPage"
    override func viewDidLoad() {
        super.viewDidLoad()
        if pageType == "HistoryPage" {
            titleLabel.text = "History"
        }else if pageType == "BillPage" {
            titleLabel.text = "Bill"
        }
        gettApi()
        let registerCell = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        historyTableView.register(registerCell, forCellReuseIdentifier: "HistoryTableViewCell")
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    

    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
   
}
extension HistoryVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageType == "HistoryPage" {
            historyListData.count
        }else{
            billListDatas.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        DispatchQueue.main.async{ [self] in
           
            if pageType == "HistoryPage" {
               
                let ListData = historyListData
                cell.paymentIDLabel.text = ListData[indexPath.row].paymentID
                cell.paymentDateLabel.text = ListData[indexPath.row].paymentDate
                cell.billStatusLabel.text = ListData[indexPath.row].billStatus
            } else if pageType == "BillPage" {
                
                let ListData = billListDatas
                cell.paymentIDLabel.text = ListData[indexPath.row].paymentID
                cell.paymentDateLabel.text = ListData[indexPath.row].paymentDate
                cell.billStatusLabel.text = ListData[indexPath.row].billStatus
            }
        }
       

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailsVC") as! HistoryDetailsVC
        if pageType == "HistoryPage" {
            vc.pageType = "HistoryPage"
            vc.paymentID = historyListData[indexPath.row].paymentID
        }else if pageType == "BillPage"{
            vc.pageType = "BillPage"
            vc.paymentID = billListDatas[indexPath.row].paymentID
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.15 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }
    
}
extension HistoryVC{
    
    func gettApi(){
        
            if self.pageType == "HistoryPage" {
                APIHandler().getAPIValues(type: HistoryListModel.self, apiUrl: APIList().urlString(url:.HistoryListApi), method: "GET") { Result in
                    DispatchQueue.main.async {
                        switch Result {
                        case.success(let data):
                            DispatchQueue.main.async { [self] in
                                self.historyListData = data.data
                                self.historyTableView.reloadData()
                            }
                        case .failure(let error):
                            print("error ---> \(error)")
                            self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                        }
                    }
                }
            }else if self.pageType == "BillPage" {
                APIHandler().getAPIValues(type: BillListModel.self, apiUrl: APIList().urlString(url:.PaymentsListApi), method: "GET") { Result in
                    DispatchQueue.main.async {
                        switch Result {
                        case.success(let data):
                            DispatchQueue.main.async { [self] in
                                self.billListDatas = data.data
                                self.historyTableView.reloadData()
                            }
                        case .failure(let error):
                            print("error ---> \(error)")
                            self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                        }
                    }
                }
            }
        }
    }

    
    

