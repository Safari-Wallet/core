//
//  EtherscanClient.swift
//  
//
//  Created by Stefano on 04.12.21.
//

import Foundation

public final class EtherscanClient {
    
    private let apiKey: String
    private let client: NetworkClient
    
    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, client:  NetworkClientImpl())
    }
    
    init(apiKey: String, client: NetworkClient) {
        self.apiKey = apiKey
        self.client = client
    }
}

// MARK: - Contracts

extension EtherscanClient {
    
    /// Returns contract details based on the contract request.
    /// - SeeAlso: [Etherscan documentation](https://docs.etherscan.io/api-endpoints/contracts)
    /// - Parameters:
    ///   - address: in hex string.
    /// - Returns: Returns contract details based on the contract request.
    public func getContractDetails(forAddress address: String) async throws -> Etherscan.ContractResponse {
        let components = makeComponents(from: address)
        return try await client.fetch(from: components)
    }
   
    private func makeComponents(from address: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.etherscan.io"
        components.path = "/api"
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "module", value: "contract"),
            URLQueryItem(name: "action", value: "getsourcecode"),
            URLQueryItem(name: "address", value: address)
        ]
        return components
    }
}
