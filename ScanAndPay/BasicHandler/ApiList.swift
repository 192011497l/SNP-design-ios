//
//  ApiList.swift
//  ScanAndPay
//
//  Created by SAIL on 04/01/24.
//

import Foundation

struct APIList
{
    
    let BASE_URL = "http://172.20.10.8/SNPios/"
    
    func urlString(url: urlString) -> String
    {
        return BASE_URL + url.rawValue
    }
}

enum urlString: String
{
    
    case EmpListAPI = "emplist.php"
    case AddEmpAPI = "insertemployee.php"
    case AddOfferAPI = "insertoffer.php"
    case OfferListAPI = "offerlist.php"
    case EmployeeDetailsAPI = "viewemp.php"
    case OfferDetailsAPI = "viewoffer.php"
    case RemoveOfferAPI = "removeoffer.php"
    case ActiveAPI = "removeemp.php"
    case NotificationListApi = "notification.php"
    case RemoveNotificationApi = "remnotifications.php"
    case ProfileApi = "profile.php"
    case RegisterApi = "register.php"
    case LoginApi = "login.php"
    case EditProfileApi = "editprofile.php"
    case HistoryListApi = "history.php"
    case ViewHistoryApi = "viewhistory.php"
    case PaymentsListApi = "payments.php"
    case ViewBillListApi = "viewpayment.php"
    case acceptApi = "accept.php"
    
    case UserProfileApi = "userprofile.php"
    case UserEditProfileApi = "userprofileedit.php"
    case UserloginApi = "userlogin.php"
    case UserRegisterApi = "userreg.php"
    case shopsApi = "shops.php"
    case cartApi = "viewcart.php"
    case RemovecartAPI = "removecart.php"
    case PaymentAPI = "his.php"
    case AddToCart = "cart.php"
    
}

