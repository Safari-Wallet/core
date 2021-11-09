//
//  UnmarshalClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/8/21.
//

import Foundation

import Foundation
import Network
import MEWwalletKit
import Alamofire

public final class UnmarshalClient {
    
    let network: Network
    let covalentKey: String
    
    public init?(network: Network = .ethereum, covalentKey: String) {
        self.network = network
        self.covalentKey = covalentKey
    }
    
    public func getTransactions(address: String) async throws -> Unmarshal.TokenTransactionsResponse {
        let req = AF.request(
            "https://stg-api.unmarshal.io/v1/ethereum/address/0xb13943b4CC5B8F03A2e2872842C7E4118abdAe6F/transactions",
            method: .get,
            parameters: [
                "auth_key": covalentKey
            ]
        )
        
        return try await withCheckedThrowingContinuation({ continuation in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            req.responseDecodable(of: Unmarshal.TokenTransactionsResponse.self, decoder: decoder) { dataResponse in
                switch dataResponse.result {
                    case .success(let response):
                        return continuation.resume(with: .success(response))
                    case .failure(let error):
                        print(error)
                        return continuation.resume(throwing: error)
                }
            }
        })
    }
   
}
