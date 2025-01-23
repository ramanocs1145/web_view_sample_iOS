//
//  NetworkManager.swift
//  web_view_sample
//
//  Created by EXAMPLE on 20/01/25.
//

import Moya

class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<APIService>()

    private init() {}

    func request<T: Decodable>(_ target: APIService, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
