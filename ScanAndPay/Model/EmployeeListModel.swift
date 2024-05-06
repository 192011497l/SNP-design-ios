//
//  EmployeeListModel.swift
//  ScanAndPay
//
//  Created by SAIL on 04/01/24.
//

import Foundation

struct EmployeeListModel: Codable {
    let status: Bool
    let message: String
    let data: [EmployeeListData]
}

// MARK: - Datum
struct EmployeeListData: Codable {
    let id, name, age, role: String
    let mobileNo, status: String

    enum CodingKeys: String, CodingKey {
        case id, name, age, role
        case mobileNo = "mobile_no"
        case status
    }
}
