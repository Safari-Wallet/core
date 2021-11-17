//
//  CovalentClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/6/21.
//

import Foundation
import Network
import MEWwalletKit 
import Alamofire

public final class CovalentClient {
    
    let apiKey: String
    
    public init?(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func getTransactions(network: Network = .ethereum,
                                address: Address) async throws -> [Covalent.Transaction] {
        let req = AF.request(
            "https://api.covalenthq.com/v1/\(network.chainID)/address/\(address.address)/transactions_v2/",
            method: .get,
            parameters: [
                "key": apiKey,
                "quote-currency": "USD"
            ]
        )
        
        return try await withCheckedThrowingContinuation({ continuation in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            req.responseDecodable(of: Covalent.Response<Covalent.GetTransactionsResponseData>.self, decoder: decoder) { dataResponse in
                switch dataResponse.result {
                    case .success(let transactionResponse):
                        return continuation.resume(with: .success(transactionResponse.data.items))
                    case .failure(let error):
                        return continuation.resume(throwing: error)
                }
            }
        })
    }
   
}
