//
//  EtherscanClient.swift
//  
//
//  Created by Stefano on 04.12.21.
//

import Foundation
import Network
import MEWwalletKit

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
    
    /*
     * https://docs.etherscan.io/api-endpoints/contracts
     */
    public func getContractDetails(forAddress address: Address) async throws -> Etherscan.ContractResponse {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.etherscan.io"
        components.path = "/api"
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "module", value: "contract"),
            URLQueryItem(name: "action", value: "getsourcecode"),
            URLQueryItem(name: "address", value: address.address)
        ]
        
        return try await client.fetch(from: components)
    }

}
