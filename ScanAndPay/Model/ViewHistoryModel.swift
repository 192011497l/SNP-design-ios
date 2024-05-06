//
//  ViewHistoryModel.swift
//  ScanAndPay
//
//  Created by SAIL on 29/01/24.
//

import Foundation


// MARK: - Welcome
struct ViewHistoryModel: Codable {
    let status: Bool
    let message: String
    let payment_id: Int
    let payment_date, bill_status: String
    let cart_data: [ViewHistoryData]

}

// MARK: - CartDatum
struct ViewHistoryData: Codable {
    let sNo, name, price, quantity: String
    let totalPrice: String

    enum CodingKeys: String, CodingKey {
        case sNo = "s_no"
        case name, price, quantity
        case totalPrice = "total_price"
    }
}
