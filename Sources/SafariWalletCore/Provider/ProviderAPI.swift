//
//  ProviderAPI.swift
//  
//
//  Created by Ronald Mannak on 11/5/21.
//

import Foundation

// Implementation of https://docs.metamask.io/guide/ethereum-provider.html and https://docs.metamask.io/guide/rpc-api.html
public struct ProviderAPI {
    
    public let delegate: SafariWalletCoreDelegate
    
    public init(delegate: SafariWalletCoreDelegate) {
        self.delegate = delegate
    }
    
    func parseMessage(method: String, params: Any?) async throws -> Any {

        guard let client = delegate.client() else { throw WalletCoreError.noClient }
        
        switch method {
            
        // MARK: - Provider API
        /*
        case "maxRetries":
            // https://docs.alchemy.com/alchemy/documentation/alchemy-web3#maxretries
            guard let amount = params as? Int else {
                return client.maxRetries
            }
            client.maxRetries = amount
            return []
            
        case "retryInterval":
            // https://docs.alchemy.com/alchemy/documentation/alchemy-web3#retryinterval
            guard let amount = params as? Int else {
                return client.retryInterval
            }
            client.retryInterval = amount
            return []
        
        case "retryJitter":
            // https://docs.alchemy.com/alchemy/documentation/alchemy-web3#retryjitter
            guard let amount = params as? Int else {
                return client.retryJitter
            }
            client.retryJitter = amount
            return []
         */
            
        case "isConnected":
            return client.isConnected
        
        case "request":
            throw WalletCoreError.notImplemented
            
        // MARK: - JSONRPC API
        case "eth_accounts":
            // https://eth.wiki/json-rpc/API#eth_accounts
            return delegate.addresses() ?? []
            
        case "eth_call":
            // https://eth.wiki/json-rpc/API#eth_call
            return try await client.ethCall(method: method, params: params ?? [])

        case "eth_getBalance":
            // https://eth.wiki/json-rpc/API#eth_getbalance
            guard let params = params as? [String], params.count == 2 else {
                throw WalletCoreError.invalidParams
            }
            let result = try await client.ethGetBalance(address: params[0], blockNumber: Block(rawValue: params[1]))
            return result.hexString
            
        case "eth_sendTransaction":
            // https://eth.wiki/json-rpc/API#eth_sendtransaction
            // FIXME: Returns mock result
            return "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331"
            
        case "eth_sign":
            // https://eth.wiki/json-rpc/API#eth_sign
            // FIXME: Returns mock result
            return "0xa3f20717a250c2b0b729b7e5becbff67fdaef7e0699da4de7ca5895b02a170a12d887fd3b17bfdce3481f10bea41f45ba9f709d39ce8325427b57afcfc994cee1b"
            
        default:
            throw WalletCoreError.unknownMethod(method)
        }
    }
}
