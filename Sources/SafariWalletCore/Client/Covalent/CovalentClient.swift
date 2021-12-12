//
//  CovalentClient.swift
//  
//
//  Created by Tassilo von Gerlach on 11/6/21.
//

import Foundation
import Network
import MEWwalletKit

public final class CovalentClient {
    
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

extension CovalentClient {
    
    /// Returns an array transactions based on the address.
    /// - Parameters:
    ///   - network: blockchain network.
    ///   - address: in hex string.
    /// - Returns: Returns an array transactions based on the address.
    public func getTransactions(network: Network = .ethereum,
                                address: Address) async throws -> [Covalent.Transaction] {
        let components = makeComponentsFrom(network: network, address: address)
        let decoder = makeDecoder()
        let response: Covalent.Response<Covalent.GetTransactionsResponseData> = try await client.fetch(from: components, decoder: decoder)
        return response.data.items
    }
    
    private func makeComponentsFrom(
        network: Network,
        address: Address
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.covalenthq.com"
        components.path = "/v1/\(network.chainID)/address/\(address.address)/transactions_v2"
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "quote-currency", value: "USD")
        ]
        return components
    }
    
    private func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
