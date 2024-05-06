//
//  LoginModel.swift
//  ScanAndPay
//
//  Created by SAIL on 10/01/24.
//

import Foundation
struct LoginModel: Codable {
    let status: Bool
    let message: String
    let data: [LoginData]
}

// MARK: - Datum
struct LoginData: Codable {
    let userID: Int
    let username, email: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case username, email
    }
}
