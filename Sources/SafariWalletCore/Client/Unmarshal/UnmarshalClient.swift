//
//  UnmarshalClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/8/21.
//

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
    
    /*
     * https://docs.unmarshal.io/unmarshal-apis/token-transactions-api
     */
    public func getTransactions(address: Address,
                                page: Int? = nil,
                                pageSize: Int? = nil) async throws -> Unmarshal.TokenTransactionsResponse {
        var parameters: Parameters = [
            "auth_key": covalentKey
        ]
        if let page = page {
            parameters["page"] = String(page)
        }
        if let pageSize = pageSize {
            parameters["pageSize"] = String(pageSize)
        }
        
        let req = AF.request(
            "https://stg-api.unmarshal.io/v1/ethereum/address/\(address.address)/transactions",
            method: .get,
            parameters: parameters
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
