//
//  PaymentModel.swift
//  ScanAndPay
//
//  Created by SAIL on 02/02/24.
//

import Foundation

struct PaymentModel: Codable {
    let data: [PaymentModelData]
    let status: Bool
    let message: String
}

// MARK: - Datum
struct PaymentModelData: Codable {
    let paymentID: Int
    let paymentDate, billStatus: String

    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case paymentDate = "payment_date"
        case billStatus = "bill_status"
    }
}
