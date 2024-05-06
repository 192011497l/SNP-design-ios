//
//  CartModel.swift
//  ScanAndPay
//
//  Created by SAIL on 02/02/24.
//

import Foundation
// MARK: - Welcome
struct CartModel: Codable {
    let status: Bool
    let message: String
    let cartDetails: [CartData]

    enum CodingKeys: String, CodingKey {
        case status, message
        case cartDetails = "cart_details"
    }
}

// MARK: - CartDetail
struct CartData: Codable {
    let sNo: Int
    let name: String
    let price, quantity, totalPrice: Int

    enum CodingKeys: String, CodingKey {
        case sNo = "s_no"
        case name, price, quantity
        case totalPrice = "total_price"
    }
}
