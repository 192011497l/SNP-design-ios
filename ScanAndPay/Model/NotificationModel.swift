//
//  NotificationModel.swift
//  ScanAndPay
//
//  Created by SAIL on 08/01/24.
//

import Foundation

struct NotificationModel: Codable {
    let status: Bool
    let message: String
    let data: [NotificationData]
}

// MARK: - Datum
struct NotificationData: Codable {
    let id, message: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case message = "Message"
    }
}
