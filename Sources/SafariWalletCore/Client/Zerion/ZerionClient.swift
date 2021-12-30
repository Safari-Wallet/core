//
//  ZerionClient.swift
//  
//
//  Created by Stefano on 30.12.21.
//

import Foundation
import Network
import MEWwalletKit
import SocketIO

public final class ZerionClient {
    
    private let apiKey: String
    private let socketManager: SocketManager
    private let socketClient: SocketIOClient
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        socketManager = SocketManager(
            socketURL: URL(string: "wss://api-v4.zerion.io")!,
            config: [
                .log(false),
                .forceWebsockets(true),
                .connectParams(["api_token": apiKey]),
                .version(.two),
                .secure(true)
            ]
        )
        socketClient = socketManager.socket(forNamespace: "/address")
    }
    
    private func connect() async throws {
        return try await withCheckedThrowingContinuation({ continuation in
            socketClient.connect()
            socketClient.on(clientEvent: .connect) { data, ack in
                continuation.resume(with: .success(()))
            }
        })
    }
}

// MARK: - Transactions

extension ZerionClient {
    
    /*
     * https://docs.zerion.io/websockets/namespaces/address
     */
    
    /// Returns an array transactions based on the address.
    /// - SeeAlso: [Documentation](https://docs.zerion.io/websockets/namespaces/address)
    /// - Parameters:
    ///   - network: blockchain network.
    ///   - address: in hex string.
    ///   - page: page number. optional
    ///   - pageSize: number of records to be displayed per page. optional
    /// - Returns: Returns an array transactions based on the address.
    public func getTransactions(network: Network = .ethereum,
                                address: Address,
                                currency: String = "usd", // TODO: Add currency enum
                                page: Int? = nil,
                                pageSize: Int? = nil) async throws -> [Zerion.Transaction] {
        try await connect() // TODO: Check if we need to connect everytime when we fetch
        
        let items: [String : Any] = [
            "scope": ["transactions"],
            "payload": [
                "address": address.address,
                "currency": currency
            ]
        ]
        
        socketClient.emit("get", items)
        
        return try await withCheckedThrowingContinuation({ continuation in
            socketClient.on("received address transactions") { data, ack in
                do {
                    let data = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let value = try decoder.decode([Zerion.Response].self, from: data).first else {
                        throw NoDataError()
                    }
                    continuation.resume(with: .success(value.payload.transactions))
                } catch let error {
                    continuation.resume(with: .failure(error))
                }
            }
        })
    }
}
