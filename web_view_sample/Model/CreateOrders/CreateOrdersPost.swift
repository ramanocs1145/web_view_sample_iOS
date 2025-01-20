//
//  CreateOrdersPost.swift
//  web_view_sample
//
//  Created by RAMANATHAN PITCHAI on 20/01/25.
//

import Foundation

struct CreateOrdersPostRepresent: Codable {
    let data: CreateOrdersPostDataRepresent?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct CreateOrdersPostDataRepresent: Codable {
    let classKey: String?
    let action: String?
    let captureMethod: String?
    let paymentToken: String?
    let orderDetails: CreateOrderDetailsDataRepresent?
    let customerDetails: CustomerDetailsDataRepresent?
    let billingDetails: BillingDetailsDataRepresent?
    let shippingDetails: ShippingDetailsDataRepresent?
    let urls: UrlsDataRepresent?
    let parameters: [CustomDataRepresent]?
    let customData: [CustomDataRepresent]?

    enum CodingKeys: String, CodingKey {
        case classKey = "class"
        case action
        case captureMethod = "capture_method"
        case paymentToken = "payment_token"
        case orderDetails = "order_details"
        case customerDetails = "customer_details"
        case billingDetails = "billing_details"
        case shippingDetails = "shipping_details"
        case urls
        case parameters
        case customData = "custom_data"
    }
}

struct CreateOrderDetailsDataRepresent: Codable {
    let mOrderId: String?
    let amount: String?
    let convenienceFee: String?
    let quantity: String?
    let currency: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case mOrderId = "m_order_id"
        case amount
        case convenienceFee = "convenience_fee"
        case quantity
        case currency
        case description
    }
}

struct CustomerDetailsDataRepresent: Codable {
    let mCustomerId: String?
    let name: String?
    let email: String?
    let mobile: String?
    let code: String?

    enum CodingKeys: String, CodingKey {
        case mCustomerId = "m_customer_id"
        case name
        case email
        case mobile
        case code
    }
}

struct BillingDetailsDataRepresent: Codable {
    let addressLine1: String?
    let addressLine2: String?
    let city: String?
    let province: String?
    let country: String?
    let pin: String?

    enum CodingKeys: String, CodingKey {
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city
        case province
        case country
        case pin
    }
}

struct ShippingDetailsDataRepresent: Codable {
    let shippingName: String?
    let shippingEmail: String?
    let shippingCode: String?
    let shippingMobile: String?
    let addressLine1: String?
    let addressLine2: String?
    let city: String?
    let province: String?
    let country: String?
    let pin: String?
    let locationPin: String?
    let shippingCurrency: String?
    let shippingAmount: String?


    enum CodingKeys: String, CodingKey {
        case shippingName = "shipping_name"
        case shippingEmail = "shipping_email"
        case shippingCode = "shipping_code"
        case shippingMobile = "shipping_mobile"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city
        case province
        case country
        case pin
        case locationPin = "location_pin"
        case shippingCurrency = "shipping_currency"
        case shippingAmount = "shipping_amount"
    }
}

// Model for 'Urls' object
struct UrlsDataRepresent: Codable {
    let success: String?
    let cancel: String?
    let failure: String?
}

// Model for 'parameters or custom_data' object (key-value pair, e.g., alpha, beta, etc.)
struct CustomDataRepresent: Codable {
    let alpha: String?
    let beta: String?
    let gamma: String?
    let delta: String?
    let epsilon: String?
}
 
// Model to represent the success response
struct CreateOrdersSuccessResponse: Codable {
    let status: String?
    let statusCode: String?
    let message: String?
    let pOrderId: Double?
    let mOrderId: String?
    let pRequestId: Double?
    let orderDreationDate: String?
    let amount: String?
    let paymentLink: String?
    let iframeLink: String?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case message
        case pOrderId = "p_order_id"
        case mOrderId = "m_order_id"
        case pRequestId = "p_request_id"
        case orderDreationDate = "order_creation_date"
        case amount
        case paymentLink = "payment_link"
        case iframeLink = "iframe_link"
    }
}
