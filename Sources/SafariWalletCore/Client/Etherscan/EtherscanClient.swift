//
//  EtherscanClient.swift
//  
//
//  Created by Stefano on 04.12.21.
//

import Foundation
import Network
import MEWwalletKit
import Alamofire

public final class EtherscanClient {
    
    let apiKey: String
    
    public init?(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /*
     * https://docs.etherscan.io/api-endpoints/contracts
     */
    public func getContractDetails(forAddress address: Address) async throws -> Etherscan.ContractResponse {
        let parameters: Parameters = [
            "apikey": apiKey,
            "module": "contract",
            "action": "getsourcecode",
            "address": address.address
        ]
        
        let req = AF.request(
            "https://api.etherscan.io/api",
            method: .get,
            parameters: parameters
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            req.responseDecodable(of: Etherscan.ContractResponse.self, decoder: decoder) { dataResponse in
                switch dataResponse.result {
                    case .success(let response):
                        return continuation.resume(with: .success(response))
                    case .failure(let error):
                        print(error)
                        return continuation.resume(throwing: error)
                }
            }
        }
    }
   
}
