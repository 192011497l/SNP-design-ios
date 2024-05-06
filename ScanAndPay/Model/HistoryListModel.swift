//
//  HistoryListModel.swift
//  ScanAndPay
//
//  Created by SAIL on 29/01/24.
//

import Foundation


// MARK: - Welcome
struct HistoryListModel: Codable {
    let status: Bool
    let message: String
    let data: [HistoryListData]

    enum CodingKeys: String, CodingKey {
        case status, message
        case data = "Data"
    }
}

// MARK: - Datum
struct HistoryListData: Codable {
    let paymentID, paymentDate, billStatus: String

    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case paymentDate = "payment_date"
        case billStatus = "bill_status"
    }
}
struct BillListModel: Codable {
    let status: Bool
    let message: String
    let data: [BillListData]
}

// MARK: - Datum
struct BillListData: Codable {
    let paymentID, paymentDate, billStatus: String

    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case paymentDate = "payment_date"
        case billStatus = "bill_status"
    }
}
