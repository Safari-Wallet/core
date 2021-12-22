//
//  EtherscanClient.swift
//  
//
//  Created by Stefano on 04.12.21.
//

import Foundation

public final class EtherscanClient {
    
    private let apiKey: String
    private let urlSession: URLSession
    
    public init(apiKey: String, urlSession: URLSession = .shared) {
        self.apiKey = apiKey
        self.urlSession = urlSession
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
        let endpoint = try makeContractDetailEndpointFrom(address: address)
        return try await urlSession.load(endpoint)
    }
    
    private func makeContractDetailEndpointFrom(
        address: String
    ) throws -> Endpoint<Etherscan.ContractResponse> {
        guard let url = URL(string: "https://api.etherscan.io/api/") else { throw InvalidRequestError() }
        let query = [
            "apikey": apiKey,
            "module": "contract",
            "action": "getsourcecode",
            "address": address
        ]
        return Endpoint(
            json: .get,
            url: url,
            query: query
        )
    }
}

extension EtherscanClient {
    
    /// Returns an array transactions based on the address.
    /// - SeeAlso: [Etherscan documentation](https://docs.etherscan.io/api-endpoints/accounts#get-a-list-of-normal-transactions-by-address)
    /// - Parameters:
    ///   - address: in hex string.
    ///   - page: page number. optional
    ///   - offset: number of records to be displayed per page. optional
    /// - Returns: Returns an array transactions based on the address.
    public func getTransactions(address: String,
                                page: Int,
                                offset: Int) async throws -> Etherscan.TransactionsResponse {
        let endpoint = try makeTransactionsEndpointFrom(address: address, page: page, offset: offset)
        return try await urlSession.load(endpoint)
    }
    
    private func makeTransactionsEndpointFrom(
        address: String,
        page: Int,
        offset: Int
    ) throws -> Endpoint<Etherscan.TransactionsResponse> {
        guard let url = URL(string: "https://api.etherscan.io/api/") else { throw InvalidRequestError() }
        let query = [
            "apikey": apiKey,
            "module": "account",
            "action": "txlist",
            "address": address,
            "startblock": "0",
            "endblock": "99999999",
            "page": String(page),
            "offset": String(offset),
            "sort": "desc",
        ]
        return Endpoint(
            json: .get,
            url: url,
            query: query
        )
    }
}
