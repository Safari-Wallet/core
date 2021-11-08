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
    
    let network: Network
    let covalentKey: String
    
    public init?(network: Network = .ethereum, covalentKey: String) {
        self.network = network
        self.covalentKey = covalentKey
    }
    
    public func getTransactions(chain: String,
                                address: String,
                                currency: String,
                                symbol: String) async throws -> [Covalent.Transaction] {
        let req = AF.request(
            "https://api.covalenthq.com/v1/\(self.network.chainID)/address/\(address)/transactions_v2/",
            method: .get,
            parameters: [
                "key": covalentKey,
                "quote-currency": currency
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
