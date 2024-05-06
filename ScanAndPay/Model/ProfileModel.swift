//
//  ProfileModel.swift
//  ScanAndPay
//
//  Created by SAIL on 09/01/24.
//

import Foundation

// MARK: - Welcome
struct ProfileModel: Codable {
    let status: Bool
    let message: String
    let data: [ProfileData]
}

// MARK: - Datum
struct ProfileData: Codable {
    let username, email, mobileNo, shopName: String

    enum CodingKeys: String, CodingKey {
        case username, email
        case mobileNo = "mobile_no"
        case shopName = "shop_name"
    }
}

