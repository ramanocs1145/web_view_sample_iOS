//
//  HomeViewModel.swift
//  web_view_sample
//
//  Created by EXAMPLE on 20/01/25.
//

import Foundation

class HomeViewModel {
    
    private let networkManager = NetworkManager.shared
    
    var checkKeysSecretSuccessResponse: CheckKeysSecretSuccessResponse?
    var ordersSuccessResponse: CreateOrdersSuccessResponse?
    
    var errorMessage: String?
    
    // Completion handler to pass success or failure response
    func fetchCreatedOrderDetails(completion: @escaping (Result<CreateOrdersSuccessResponse, Error>) -> Void) {
        
        // First, call checkKeysSecret endpoint
        checkKeysSecret { [weak self] result in
            switch result {
            case .success:
                // If checkKeysSecret is successful, call createOrders
                self?.createOrders(completion: completion)
                
            case .failure(let error):
                // If checkKeysSecret fails, pass the error to the completion handler
                completion(.failure(error))
            }
        }
    }
    
    // Private method to handle the checkKeysSecret API call
    private func checkKeysSecret(completion: @escaping (Result<Void, Error>) -> Void) {
        let checkKeysSecretPostDataRepresent = CheckKeysSecretPostDataRepresent(merchantKey: (Configuration.shared.merchantKey ?? ""), merchantSecret: (Configuration.shared.merchantSecret ?? ""), env: (Configuration.shared.environment ?? ""))
        networkManager.request(.checkKeysSecret(checkKeysSecretPostDataRepresent: checkKeysSecretPostDataRepresent)) { [weak self] (result: Result<CheckKeysSecretSuccessResponse, Error>) in
            switch result {
            case .success(let checkKeysSecretSuccessResponse):
                self?.checkKeysSecretSuccessResponse = checkKeysSecretSuccessResponse
                completion(.success(())) // Trigger success for checkKeysSecret
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(.failure(error)) // Pass error for checkKeysSecret failure
            }
        }
    }
    
    // Private method to handle the createOrders API call
    private func createOrders(completion: @escaping (Result<CreateOrdersSuccessResponse, Error>) -> Void) {
        
        let createOrderDetailsDataRepresent = CreateOrderDetailsDataRepresent(mOrderId: "1234", amount: "100", convenienceFee: "0", quantity: "2", currency: "AED", description: "")
        
        let customerDetailsDataRepresent = CustomerDetailsDataRepresent(mCustomerId: "123", name: "John Doe", email: "pawan@payorc.com", mobile: "987654321", code: "971")

        let billingDetailsDataRepresent = BillingDetailsDataRepresent(addressLine1: "address 1", addressLine2: "address 2", city: "Amarpur", province: "Bihar", country: "IN", pin: "482008")
        
        let shippingDetailsDataRepresent = ShippingDetailsDataRepresent(shippingName: "Pawan Kushwaha", shippingEmail: "", shippingCode: "91", shippingMobile: "9876543210", addressLine1: "address 1", addressLine2: "address 2", city: "Jabalpur", province: "Madhya Pradesh", country: "IN", pin: "482005", locationPin: "https://location/somepoint", shippingCurrency: "AED", shippingAmount: "10")

        let urlsDataRepresent = UrlsDataRepresent(success: "", cancel: "", failure: "")
        
        let customDataRepresent = [CustomDataRepresent(alpha: "", beta: "", gamma: "", delta: "", epsilon: "")]
        
        let createOrdersPostDataRepresent = CreateOrdersPostDataRepresent(classKey: "ECOM", action: "SALE", captureMethod: "MANUAL", paymentToken: "", orderDetails: createOrderDetailsDataRepresent, customerDetails: customerDetailsDataRepresent, billingDetails: billingDetailsDataRepresent, shippingDetails: shippingDetailsDataRepresent, urls: urlsDataRepresent, parameters: customDataRepresent, customData: customDataRepresent)

        let createOrdersPostRepresent = CreateOrdersPostRepresent(data: createOrdersPostDataRepresent)

        networkManager.request(.createOrders(createOrdersPostRepresent: createOrdersPostRepresent)) { [weak self] (result: Result<CreateOrdersSuccessResponse, Error>) in
            switch result {
            case .success(let ordersSuccessResponse):
                self?.ordersSuccessResponse = ordersSuccessResponse
                completion(.success(ordersSuccessResponse)) // Pass the success response
                
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(.failure(error)) // Pass the error for createOrders failure
            }
        }
    }
}
