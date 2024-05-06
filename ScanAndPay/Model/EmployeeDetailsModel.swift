//
//  EmployeeDetailsModel.swift
//  ScanAndPay
//
//  Created by SAIL on 05/01/24.
//

import Foundation
// MARK: - Welcome
struct EmployeeDetailsModel: Codable {
    let status: Bool
    let message: String
    let data: [EmployeeDetailsData]
}

// MARK: - Datum
struct EmployeeDetailsData: Codable {
    let name, email: String
    let mobileNo, age: Int
    let qualification, experience, role, address: String

    enum CodingKeys: String, CodingKey {
        case name, email
        case mobileNo = "mobile_no"
        case age, qualification, experience, role, address
    }
}
