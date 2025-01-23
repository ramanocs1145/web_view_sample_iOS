//
//  APIService.swift
//  web_view_sample
//
//  Created by EXAMPLE on 20/01/25.
//

import Moya

enum APIService {
    case checkKeysSecret(checkKeysSecretPostDataRepresent :CheckKeysSecretPostDataRepresent)
    case createOrders(createOrdersPostRepresent :CreateOrdersPostRepresent)
}

extension APIService: TargetType {
    var path: String {
        switch self {
        case .checkKeysSecret:
            return "v1/check/keys-secret"
        case .createOrders:
            return "v1//open/orders/create"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkKeysSecret, .createOrders:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkKeysSecret(let checkKeysSecretPostDataRepresent):
            // Print the JSON string before encoding it
            printJSON(checkKeysSecretPostDataRepresent)
            
            // Encoding the parameters into the request body as JSON
            return .requestJSONEncodable(checkKeysSecretPostDataRepresent)
            
        case .createOrders(let createOrdersPostRepresent):
            // Print the JSON string before encoding it
            printJSON(createOrdersPostRepresent)
            
            // Encoding the parameters into the request body as JSON
            return .requestJSONEncodable(createOrdersPostRepresent)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .checkKeysSecret(_):
            return ["Content-Type": "application/json"]
            
        case .createOrders(_):
            return [
                "merchant-key": "test-JR11KGG26DM",
                "merchant-secret": "sec-DC111UM26HQ",
                "Content-Type": "application/json"
            ]
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://nodeserver.payorc.com/api/")!
    }
    
    // Generic method to print any Encodable object as JSON
    private func printJSON<T: Encodable>(_ object: T) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                debugPrint("JSON String for \(T.self): \(jsonString)")
            }
        } catch {
            debugPrint("Failed to encode \(T.self) to JSON: \(error.localizedDescription)")
        }
    }
}
