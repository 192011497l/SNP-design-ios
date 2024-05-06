//
//  ViewBillModel.swift
//  ScanAndPay
//
//  Created by SAIL on 30/01/24.
//

import Foundation
// MARK: - Welcome
struct ViewBillModel: Codable {
    let status: Bool
    let message, paymentID, paymentDate, billStatus: String
    let cartData: [ViewBillData]

    enum CodingKeys: String, CodingKey {
        case status, message
        case paymentID = "payment_id"
        case paymentDate = "payment_date"
        case billStatus = "bill_status"
        case cartData = "cart_data"
    }
}

// MARK: - CartDatum
struct ViewBillData: Codable {
    let sNo, name, price, quantity: String
    let totalPrice: String

    enum CodingKeys: String, CodingKey {
        case sNo = "s_no"
        case name, price, quantity
        case totalPrice = "total_price"
    }
}
