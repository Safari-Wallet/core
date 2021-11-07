//
//  File.swift
//  
//
//  Created by Ronald Mannak on 11/5/21.
//

import Foundation

// Implementation of https://docs.metamask.io/guide/rpc-api.html
struct ProviderRPC {
    
    let client: JsonRpcClient
    
    /// The number of times the client will attempt to resend a rate limited request before giving up. Default: 3.
    /// See https://docs.alchemy.com/alchemy/documentation/alchemy-web3#maxretries
    var maxRetries = 3
    
    /// The minimum time waited between consecutive retries, in milliseconds. Default: 1000.
    /// See https://docs.alchemy.com/alchemy/documentation/alchemy-web3#retryinterval
    var retryInterval = 1000
        
    /// A random amount of time is added to the retry delay to help avoid additional rate errors caused by too many concurrent connections,
    /// chosen as a number of milliseconds between 0 and this value. Default: 250.
    /// See https://docs.alchemy.com/alchemy/documentation/alchemy-web3#retryjitter
    var retryJitter = 250

    func parseCall(call: [String: Any]) async throws -> Any {
        
        guard let method = call["method"] as? String else { throw WalletCoreError.noMethod }
        guard let params = call["params"] else { throw WalletCoreError.noParameters }
        
        switch method {
        case "eth_getBalance":
            // https://eth.wiki/json-rpc/API#eth_getbalance
            return try await client.makeRequest(method: method, resultType: String.self)
            /*
             {
               "id":73,
               "jsonrpc": "2.0",
               "result": "0x1dfd14000" // 8049999872 Wei
             }
             */
            
        case "eth_sendTransaction":
            // https://eth.wiki/json-rpc/API#eth_sendtransaction
            return try await client.makeRequest(method: method, resultType: String.self)
            
        case "somethingElse":
            return try await client.makeRequest(method: method, resultType: [String].self)
            
        case "somethingElse2":
            return try await client.makeRequest(method: method, resultType: Bool.self)
        
        case "somethingElse3":
            return try await client.makeRequest(method: method, resultType: [String: String].self)
            
        default:
            throw WalletCoreError.unknownMethod(method)
        }
        
    }
    
    
//    eth_accounts (opens new window)
//    eth_call (opens new window)
//    eth_getBalance (opens new window)
//    eth_sendTransaction (opens new window)
//    eth_sign (opens new window)
    
}
