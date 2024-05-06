//
//  NotificationVC.swift
//  ScanAndPay
//
//  Created by SAIL on 08/01/24.
//

import UIKit

class NotificationVC: BasicVC {

    
    @IBOutlet weak var TableView: UITableView!{
        didSet{
            TableView.delegate = self
            TableView.dataSource = self
        }
    }
    @IBOutlet weak var clearButton : UIButton!
    var notificationArrayData  : NotificationModel?
    
    override func viewWillAppear(_ animated: Bool) {
        getApi()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
        clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)

        let registerCell = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        TableView.register(registerCell, forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    @objc func clearButtonAction(){
        
        
        postAPI(IdNumber: "")
      
      
    }
   

}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArrayData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.tableLabel.text = notificationArrayData?.data[indexPath.row].message
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.3 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
}
extension NotificationVC{
    
    func getApi(){
        
        APIHandler().getAPIValues(type: NotificationModel.self, apiUrl: APIList().urlString(url:.NotificationListApi), method: "GET") { Result in
            switch Result {
            case.success(let data):
                DispatchQueue.main.async { [self] in
                    notificationArrayData = data
                    self.TableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async { [self] in
                    print("error ---> \(error)")
                    self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})}
            }
        }
    }
    func postAPI(IdNumber : String){
        
        let formData = ["":""]
        let apiURL = APIList().urlString(url:.RemoveNotificationApi)
                        print(apiURL)
                           APIHandler().postAPIValues(type: AddEmployeeModel.self, apiUrl: apiURL, method: "POST", formData: formData) {  result in
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
