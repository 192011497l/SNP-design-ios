//
//  PaymentPageVc.swift
//  ScanAndPay
//
//  Created by SAIL on 21/02/24.
//

import UIKit
import Razorpay

class PaymentPageVc: BasicVC {

    let razorpayTestKey = "rzp_test_5rwYE521v89m4u"
    var razorpay: RazorpayCheckout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        razorpay = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
    }
    
    @IBAction func payAction() {
       
    }

   
}
extension PaymentPageVc : RazorpayPaymentCompletionProtocol {
  func onPaymentError(_ code: Int32, description str: String) {
    print("error: ", code, str)

    showAlert(title: "Alert", message: "Payment Failure")
  }
  func onPaymentSuccess(_ payment_id: String) {
    print("success: ", payment_id)
      showAlert(title: "Success", message: "Payment Succeeded")
   }
   
}

