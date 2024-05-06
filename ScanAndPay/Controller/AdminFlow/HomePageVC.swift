//
//  HomePageVC.swift
//  ScanAndPay
//
//  Created by SAIL on 02/01/24.
//

import UIKit

class HomePageVC: BasicVC, SlideMenuProto {
    
    @IBOutlet weak var homeTableView: UITableView!{
        didSet{
            homeTableView.delegate = self
            homeTableView.dataSource = self
        }
    }
    @IBOutlet weak var addButton : UIButton!
    @IBOutlet weak var backButton : UIButton!

    var backButtonBool : Bool = false
    
    var tableArray = ["Scan","My Payments","Offers"]
    var tableImageArray = ["bill","employee","Offer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if backButtonBool{
            backButton.isHidden = false
        }else{
            backButton.isHidden = true
        }
        if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
            tableArray = ["History","Employee Management","Offers","Bill"]
             tableImageArray = ["bill","employee","Offer","bill"]
        }
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        let registerCell = UINib(nibName: "HomeTableViewCell", bundle: nil)
        homeTableView.register(registerCell, forCellReuseIdentifier: "HomeTableViewCell")
        
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addButtonAction(){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SlideMenuVc") as! SlideMenuVc
        vc.sideDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
}
extension HomePageVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.tableLabel.text = tableArray[indexPath.row]
        cell.tableImage.image = UIImage(named: tableImageArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           // Initial state for animation
           cell.alpha = 0

           // Animation when the cell is about to be displayed with delay
           UIView.animate(withDuration: 1, delay: 0.3 * Double(indexPath.row), options: .curveEaseInOut, animations: {
               cell.alpha = 1
           }, completion: nil)
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
            if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
                if indexPath.row ==  0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
                    vc.pageType = "HistoryPage"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row ==  1 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListOfEmployeeVC") as! ListOfEmployeeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row ==  2 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OffersVC") as! OffersVC
                    vc.backButtonConnection = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if indexPath.row ==  3 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
                    vc.pageType = "BillPage"
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    
                }
            }else{
                if indexPath.row ==  0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanPageVC") as! ScanPageVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row ==  1 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row ==  2 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OffersVC") as! OffersVC
                    vc.backButtonConnection = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
//        }
    }
    func onSideMenu(menuNo: Int) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if menuNo == 1 {
//            let vc = storyboard.instantiateViewController(withIdentifier: "Doctors_HomePG") as! Doctors_HomePG
//            self.navigationController?.pushViewController(vc, animated: true)
           
        }
        else if menuNo == 2 {
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfilePageVC") as! ProfilePageVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuNo == 3 {
            if UserDefaultsManager.shared.getValue(forKey: "UserProfile") == "Admin" {
                let vc = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
                vc.pageType = "HistoryPage"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
                vc.pageType = "BillPage"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if menuNo == 4 {
            
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginPageVC") as! LoginPageVC
                self.navigationController?.pushViewController(vc, animated: true)
        }else {
            print("LOGOUT MUST BE DONE")
        }
        
    }
}
    

