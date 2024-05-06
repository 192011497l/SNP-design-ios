//
//  OfferListModel.swift
//  ScanAndPay
//
//  Created by SAIL on 04/01/24.
//

import Foundation

// MARK: - Welcome
struct OfferListModel: Codable {
    let status: Bool
    let message: String
    let data: [OfferListData]
}

// MARK: - Datum
struct OfferListData: Codable {
    let id, offerName: String

    enum CodingKeys: String, CodingKey {
        case id
        case offerName = "offer_name"
//        case expiryDate = "expiry_date"
//        case offerDetails = "offer_details"
    }
}
