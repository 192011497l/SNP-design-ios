//
//  UserProfile.swift
//  ScanAndPay
//
//  Created by SAIL on 05/02/24.
//

import Foundation
struct UserProfileModel: Codable {
    let status: Bool
    let message: String
    let data: [UserProfileData]
}

// MARK: - Datum
struct UserProfileData: Codable {
    let username, email, mobileNo: String

    enum CodingKeys: String, CodingKey {
        case username, email
        case mobileNo = "mobile_no"
    }
}
