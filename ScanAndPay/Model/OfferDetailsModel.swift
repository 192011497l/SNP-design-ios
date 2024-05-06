//
//  OfferDetailsModel.swift
//  ScanAndPay
//
//  Created by SAIL on 08/01/24.
//

import Foundation
struct OfferDetailsModel: Codable {
    let status: Bool
    let message: String
    let data: [OfferDetailsData]
}

// MARK: - Datum
struct OfferDetailsData: Codable {
    let offerName, expiryDate, offerDetails: String

    enum CodingKeys: String, CodingKey {
        case offerName = "offer_name"
        case expiryDate = "expiry_date"
        case offerDetails = "offer_details"
    }
}
