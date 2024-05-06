//
//  ShopModel.swift
//  ScanAndPay
//
//  Created by SAIL on 09/01/24.
//

import Foundation
struct ShopModel: Codable {
    let status: Bool
    let message: String
    let data: [ShopData]
}

// MARK: - Datum
struct ShopData: Codable {
    let shopName, shopAddress: String

    enum CodingKeys: String, CodingKey {
        case shopName = "shop_name"
        case shopAddress = "shop_address"
    }
}
