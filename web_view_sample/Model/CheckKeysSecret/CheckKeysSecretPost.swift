//
//  CheckKeysSecretPost.swift
//  web_view_sample
//
//  Created by RAMANATHAN PITCHAI on 20/01/25.
//

import Foundation

struct CheckKeysSecretPostDataRepresent: Codable {
    let merchantKey: String?
    let merchantSecret: String?
    let env: String?
    
    enum CodingKeys: String, CodingKey {
        case merchantKey = "merchant_key"
        case merchantSecret = "merchant_secret"
        case env
    }
}

struct CheckKeysSecretSuccessResponse: Codable {
    let message: String?
    let status: String?
    let code: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case status
        case code
    }
}
