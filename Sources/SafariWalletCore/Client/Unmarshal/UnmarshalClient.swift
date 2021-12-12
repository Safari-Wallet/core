//
//  UnmarshalClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/8/21.
//

import Foundation
import Network
import MEWwalletKit

public final class UnmarshalClient {
    
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

// MARK: - Transactions

extension UnmarshalClient {
    
    /*
     * https://docs.unmarshal.io/unmarshal-apis/token-transactions-api
     */
    
    /// Returns an array transactions based on the address.
    /// - SeeAlso: [Unmarshal documentation](https://docs.unmarshal.io/unmarshal-apis/token-transactions-api)
    /// - Parameters:
    ///   - network: blockchain network.
    ///   - address: in hex string.
    ///   - page: page number. optional
    ///   - pageSize: number of records to be displayed per page. optional
    /// - Returns: Returns an array transactions based on the address.
    public func getTransactions(network: Network = .ethereum,
                                address: Address,
                                page: Int? = nil,
                                pageSize: Int? = nil) async throws -> Unmarshal.TokenTransactionsResponse {
        let components = makeComponentsFrom(network: network, address: address, page: page, pageSize: pageSize)
        return try await client.fetch(from: components)
    }
   
    private func makeComponentsFrom(
        network: Network,
        address: Address,
        page: Int? = nil,
        pageSize: Int? = nil
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "stg-api.unmarshal.io"
        components.path = "/v1/\(network.name.lowercased())/address/\(address.address)/transactions"
        components.queryItems = [
            URLQueryItem(name: "auth_key", value: apiKey)
        ]
        
        if let page = page {
            components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let pageSize = pageSize {
            components.queryItems?.append(URLQueryItem(name: "pageSize", value: String(pageSize)))
        }
        return components
    }
}
